#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"

# Parameters (not mandatory)
# -o / --open-org : navigate to the deploy page of the org
# -t / --test : execute unit tests while performing deployment
# -v / --validate : validate the deployment of all source files in a directory to the default org
# -s / --shutdown : added shutdown option at the end of deployment (error or success of deployment)
option=$1

# Parameters (not mandatory)
# -s / --shutdown : added shutdown option at the end of deployment (error or success of deployment)
shutdown=$2

main(){
	display_start_time
	check_update_of_git
	check_update_for_global_npm_packages
	block_deploy_from_master_branch
	if [[ "$current_branch" = "preprod" || "$current_branch" = "prod-release" ]]; then
		pull_last_commits_on_current_branch
	fi
	check_current_org_type
	if [ "$is_production_org" = "false" ]; then
		edit_files_that_fail_deployment
		install_managed_packages $(get_org_alias)
	fi
	trap ctrl_c SIGINT
	deploy_files_into_current_org
	if [ "$is_production_org" = "false" ]; then
		if [[ $(yq eval '.org_settings.territories_used // "null"' "$config_file") = "true" ]]; then
			deploy_territories_into_current_org
		fi
		restore_edited_files
		if [ "$current_branch" = "preprod" ]; then
			store_last_deployed_commit_hash
		fi
	elif [ "$current_branch" = "prod-release" ]; then
		if [[ "$is_production_org" = "true" && ("$option" = "-v" || "$option" = "--validate") ]]; then
			error_exit "You need to manually deploy the package in the org to finalize the deployment. Don't forget to update the master branch after."
		else
			merge_prod_release_into_master
			delete_remote_branches_merged_into_master
		fi
	fi
	if [[ "$is_scratch_org" = "true" || ("$is_sandbox_org" = "true" && "$current_branch" != "preprod") ]]; then
		reset_tracking_in_scratch_org
	fi
	display_duration_of_script
	if [[ -n "$shutdown" || "$option" = "-s" || "$option" = "--shut-down" ]]; then
		cmd.exe /c "shutdown /s /t 0"
	fi
}

block_deploy_from_master_branch(){
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	if [ "$current_branch" = "master" ]; then
		error_exit "Script cannot run on master branch."
	fi
}

pull_last_commits_on_current_branch(){
	echo -ne "\nPulling last commits on current branch... "
	yes y | git fetch origin $current_branch > /dev/null 2>&1
	yes y | git pull origin $current_branch > /dev/null 2>&1
	echo "Done."
}

check_current_org_type(){
	echo -ne "\nChecking current org type... "
	is_production_org=$(check_production_org)
	is_scratch_org=$(check_scratch_org)
	is_sandbox_org=$(check_sandbox_org)
	echo "Done."
}

edit_files_that_fail_deployment(){
	echo -e "\nRemoving content of metadata files that fail deployment :"
	if [ -d "${project_directory}connectedApps/" ]; then
		remove_consumer_key_on_each_connected_app
	fi
	remove_missing_sobjects_from_viewallrecords_permission_sets
	add_missing_sobjects_in_viewallrecords_permission_sets
	if [ "$is_scratch_org" = "true" ]; then
		remove_users_from_queues
		if [ -d "${project_directory}sites/" ]; then
			remove_domain_on_each_site
		fi
		if [ -d "${project_directory}autoResponseRules/" ]; then
			replace_sender_email_in_case_autoresponse_rule
		fi
	fi
}

ctrl_c(){
	echo -ne "\n${RYellow}Aborting deployment... ${NC}"
	sf project deploy cancel --use-most-recent > /dev/null
	echo -e "${RYellow}Done${NC}"
	exit 1
}

deploy_files_into_current_org(){
	get_additional_deploy_parameters

	if [[ "$option" = "-o" || "$option" = "--open-org" ]]; then
		echo
		sf org open -p lightning/setup/DeployStatus/home
	fi

	local type_of_deploy="start"
	if [[ "$is_production_org" = "true" && ("$option" = "-v" || "$option" = "--validate") ]]; then
		type_of_deploy="validate"
	fi

	echo -e "\nDeploying ${RBlue}project metadata files${NC} to org... "
	local deploy_files_result=$(sf project deploy $type_of_deploy -x manifest/full.xml -w 600 --json$additional_deploy_parameters)
	local deployment_status=$(echo "$deploy_files_result" | jq -r '.status')

	if [ "$deployment_status" -eq 0 ]; then
		echo -e "${RGreen}Deployment successful.${NC}"

		if [ -e "postDeployDestructiveChanges.xml" ]; then
			rm "postDeployDestructiveChanges.xml"
		fi

		if [ "$current_branch" = "preprod" ]; then
			jq --arg current_commit_hash_or_branch "$current_commit_hash_or_branch" '.lastDeployedCommit = $current_commit_hash_or_branch' "$config_json" > "$config_json.tmp" && mv "$config_json.tmp" "$config_json"
		fi
	else
		echo -e "${RRed}Deployment failed. Fix the errors then relaunch the script.${NC}"
		local deployment_message=$(echo "$deploy_files_result" | jq -r '.message')
		if [[ -n "$deployment_message" ]]; then
			echo -e "${RRed}Error: ${deployment_message}${NC}"
		fi
		if [ "$is_production_org" = "false" ]; then
			restore_edited_files
		fi
		display_duration_of_script
		if [[ -n "$shutdown" || "$option" = "-s" || "$option" = "--shut-down" ]]; then
			shutdown /s /t 0
		else
			local deploy_url=$(echo "$deploy_files_result" | jq -r '.result.deployUrl')
			if [[ -n "$deploy_url" ]]; then
				sf org open -p "$deploy_url"
			fi
		fi
		exit 1
	fi
}

get_additional_deploy_parameters(){
	additional_deploy_parameters=""

	add_option_to_delete_deleted_or_renamed_files

	if [ "$is_production_org" = "false" ]; then
		additional_deploy_parameters+=" --ignore-conflicts"
	fi

	if [[ "$is_production_org" = "true" || "$option" = "-t" || "$option" = "--test" ]]; then
		additional_deploy_parameters+=" -l RunLocalTests"
	fi
}

add_option_to_delete_deleted_or_renamed_files(){
	if [ "$current_branch" = "preprod" ]; then
		config_json=".preprod/config.json"
		if ! [ -e "$config_json" ]; then
			error_exit "You need a 'config.json' file in the folder '.preprod/' with a property called 'lastDeployedCommit' that represents the last deployed commit hash in preprod."
		fi
		current_commit_hash_or_branch=$(git rev-parse HEAD)
		local last_deployed_commit=$(jq -r '.lastDeployedCommit' "$config_json")

		local commit_timestamp=$(git log -1 --format="%ct" $last_deployed_commit)
		commit_hash_or_branch_reference=$(git log --since="$commit_timestamp" --reverse --format="%H" --first-parent "$current_branch" | awk -v last_commit="$last_deployed_commit" 'BEGIN { found=0; } { if (found) { print $1; exit; } if ($1 == last_commit) found=1; }')

		if [ -z "$commit_hash_or_branch_reference" ]; then
			commit_hash_or_branch_reference=$(git log --since="$commit_timestamp" --reverse --format="%H" --first-parent "$current_branch" | awk 'NR==1{print $1; exit}')
		fi

		if [[ "$commit_hash_or_branch_reference" = "null" || -z "$commit_hash_or_branch_reference" ]]; then
			error_exit "In '.preprod/config.json' file, you need a property called 'lastDeployedCommit' with a value that represents the last deployed commit hash in preprod."
		fi

		echo -e "\nDeploying into preprod since commit : ${RGreen}${commit_hash_or_branch_reference}${NC}"
	else
		current_commit_hash_or_branch="$current_branch"
		commit_hash_or_branch_reference="master"
	fi

	echo -ne "\nChecking if files have been deleted from project... "
	local deleted_files=$(git diff --diff-filter=D --name-only $commit_hash_or_branch_reference^ $current_commit_hash_or_branch | awk '$1 ~ /-meta.xml$/ && $1 ~ /^force-app\/main\/default\//')
	local renamed_files=$(find_renamed_files)
	local deleted_labels=$(find_deleted_labels)

	if [[ -n "$deleted_files" || -n "$renamed_files" || -n "$deleted_labels" ]]; then
		echo -n "Deleted files found."
		echo -ne "\nGenerating ${RCyan}postDeployDestructiveChanges.xml${NC} to perform deletion on post deployment... "
		local generated_xml=$(generate_post_deploy_destructive_changes_xml "${deleted_files}\n${renamed_files}\n${deleted_labels}")

		if grep -q "Metadata type not found" <<< "$generated_xml"; then
			error_exit "$generated_xml"
		fi

		echo "$generated_xml" > postDeployDestructiveChanges.xml
		additional_deploy_parameters+=" --ignore-warnings --post-destructive-changes postDeployDestructiveChanges.xml --purge-on-delete"
		echo "Done."
	else
		echo "No deleted files found."
	fi
}

find_renamed_files(){
	local renamed_or_moved_files=$(git diff --diff-filter=R --name-status $commit_hash_or_branch_reference^ $current_commit_hash_or_branch | awk '$1 ~ /^R/ && $2 ~ /-meta.xml$/ && $2 ~ /^force-app\/main\/default\// {print $2}')

	local files_to_delete=""
	if [[ -n "$renamed_or_moved_files" ]]; then
		while IFS= read -r fileFullPath; do
			if [[ $fileFullPath == ${project_directory}classes/* ]]; then
				apex_class=$(basename "$fileFullPath" | sed 's/-meta\.xml$//')
				if find "${project_directory}classes/" -name "$apex_class" -print -quit | grep -q .; then
					continue
				else
					files_to_delete+="${fileFullPath}\n"
				fi
			else
				files_to_delete+="${fileFullPath}\n"
			fi
		done <<< "$renamed_or_moved_files"
	fi

	echo $files_to_delete
}

find_deleted_labels(){
	local diff_on_custom_labels=$(git diff $commit_hash_or_branch_reference^ $current_commit_hash_or_branch "${project_directory}labels/CustomLabels.labels-meta.xml")
	local removed_labels=$(echo "$diff_on_custom_labels" | grep -E '^-\s*<fullName>' | awk -F'[<>]' '/<fullName>/{gsub(/^ +/, ""); print $3}' | sed "s|^|${project_directory}label/|")

	local labels_to_delete=""
	if [[ -n "$removed_labels" ]]; then
		while IFS= read -r fileFullPath; do
			if [[ $fileFullPath == ${project_directory}* ]]; then
				label=$(basename "$fileFullPath" | sed 's/\.[^.]*-meta\.xml$//')
				if grep -q "<fullName>$label</fullName>" "${project_directory}labels/CustomLabels.labels-meta.xml"; then
					continue
				else
					labels_to_delete+="${fileFullPath}\n"
				fi
			fi
		done <<< "$removed_labels"
	fi

	echo $labels_to_delete
}

generate_post_deploy_destructive_changes_xml(){
	local files_to_delete=$(echo -e $1)

	files_to_delete=$(echo "$files_to_delete" | tr ' ' '\n')

	declare -A fileNames_by_metadata_type

	while IFS= read -r fileFullPath; do
		if [[ $fileFullPath == ${project_directory}* ]]; then
			local folder=$(echo "$fileFullPath" | awk -F '/' '{print $4}')

			case $folder in
				"assignmentRules" | "audience" | "autoResponseRules" | "dashboards" | "documents" | "escalationRules" | "experiences" | "managedTopics" | "matchingRules" | "moderation" | "navigationMenus" | "networkBranding" | "networks" | "objectTranslations" | "profiles" | "reports" | "recordTypes" | "reportTypes" | "settings" | "sharingRules" | "siteDotComSites" | "sites" | "standardValueSets" | "territory2Models" | "territory2Types" | "translations" | "userCriteria" | "workflows")
					continue
					;;
			esac

			local fileName=$(basename "$fileFullPath" | sed 's/\.[^.]*-meta\.xml$//')
			if [[ $folder = objects && $fileFullPath != *.object-meta.xml ]]; then
				local sobject=$(echo "$fileFullPath" | awk -F '/' '{print $5}')
				sub_folder=$(echo "$fileFullPath" | awk -F '/' '{print $6}')
				metadata_type=$(find_metadata_type_by_folder_name "$sub_folder")
				fileName="${sobject}.${fileName}"
			else
				metadata_type=$(find_metadata_type_by_folder_name "$folder")
			fi

			if [ -z "$metadata_type" ]; then
				error_exit "Metadata type not found for folder '$folder$sub_folder'"
			fi

			if [[ "$metadata_type" == "CustomField" && ! "$fileName" =~ __c$ ]]; then
				continue
			fi

			fileNames_by_metadata_type["$metadata_type"]+="$fileName "
		fi
	done <<< "$files_to_delete"

	# Generate XML package
	echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	echo "<Package xmlns=\"${xml_namespace}\">"

	for metadata_type in $(echo "${!fileNames_by_metadata_type[@]}" | tr ' ' '\n' | sort); do
		echo -e "\t<types>"
		IFS=' ' read -ra fileNames <<< "${fileNames_by_metadata_type[$metadata_type]}"
		for fileName in $(echo "${fileNames[@]}" | sort); do
			echo -e "\t\t<members>$fileName</members>"
		done
		echo -e "\t\t<name>$metadata_type</name>"
		echo -e "\t</types>"
	done

	echo -e "\t<version>63.0</version>"
	echo "</Package>"
}

deploy_territories_into_current_org(){
	echo -ne "\nDeploying ${RCyan}territories${NC} to org... "
	local deploy_territories_result=$(sf project deploy start -x manifest/territories.xml --ignore-conflicts --ignore-warnings --json)
	echo "Done."
}

restore_edited_files(){
	echo -ne "\nResetting changes in files... "
	local modified_directories=(
		"connectedApps"
	)
	if [ "$is_production_org" = "false" ]; then
		modified_directories+=("permissionsets")
		if [ "$is_scratch_org" = "true" ]; then
			modified_directories+=("queues" "autoResponseRules" "sites")
		fi
	fi
	for dir in "${modified_directories[@]}"; do
		git restore "${project_directory}${dir}" > /dev/null 2>&1
	done
	echo "Done."
}

store_last_deployed_commit_hash(){
	echo -e "\nAdding last deployed commit hash to .preprod/config.json..."
	yes y | git fetch origin preprod > /dev/null
	yes y | git pull origin preprod > /dev/null
	yes y | git add .preprod/config.json > /dev/null
	yes y | git commit -m "Updated last commit hash deployed in preprod" > /dev/null
	yes y | git push origin preprod > /dev/null
}

reset_tracking_in_scratch_org(){
	echo -ne "Resetting ${RGreen}tracking${NC} on scratch org... "
	sf project reset tracking -p > /dev/null
	echo "Done."
}

main