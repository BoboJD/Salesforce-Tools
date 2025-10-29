#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"

# Parameters (not mandatory)
# -f / --full-deploy : perform a full deployment of all source files to the default org
# -dc / --deploy-changes / -lc / --local-changes : perform a deployment of all files that has been changed (git status)
# -v / --validate : validate the deployment to the default org
# -t / --test [classNames] : execute unit tests while performing deployment. Optional comma-separated class names
# -s / --shutdown : shutdown computer at the end of deployment (error or success of deployment)

# Initialize parameters
full_deploy=false
use_git_status_mode=false
validate=false
run_apex_tests=false
test_classes=""
shutdown=false

# Parse command line options
while [[ $# -gt 0 ]]; do
	case $1 in
		-f|--full-deploy)
			full_deploy=true
			shift
			;;
		-dc|--deploy-changes|-lc|--local-changes)
			use_git_status_mode=true
			shift
			;;
		-v|--validate)
			validate=true
			shift
			;;
		-t|--test)
			run_apex_tests=true
			shift
			if [[ $# -gt 0 && ! $1 =~ ^- ]]; then
				test_classes=$1
				shift
			fi
			;;
		-s|--shutdown)
			shutdown=true
			shift
			;;
		*)
			echo "Invalid option: $1" >&2
			exit 1
			;;
	esac
done

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
		install_packages $(get_org_alias)
		edit_files_that_fail_deployment
	fi
	trap ctrl_c SIGINT
	deploy_files_into_current_org
	if [ "$is_production_org" = "false" ]; then
		if [[ "$full_deploy" = true && $(yq eval '.org_settings.territories_used // "null"' "$config_file") = "true" ]]; then
			deploy_territories_into_current_org
		fi
		restore_edited_files
		if [ "$current_branch" = "preprod" ]; then
			store_last_deployed_commit_hash
		fi
	elif [ "$current_branch" = "prod-release" ]; then
		if [[ "$is_production_org" = "true" && "$validate" = true ]]; then
			echo -e "${RGreen}You need to manually deploy the package in the org to finalize the deployment. Don't forget to update the master branch after, you can run 'make release' while being on prod-release branch to do this.${NC}"
			exit 1
		else
			merge_prod_release_into_master
			delete_remote_branches_merged_into_master
		fi
	fi
	if [[ "$is_scratch_org" = "true" || ("$is_sandbox_org" = "true" && "$current_branch" != "preprod") ]]; then
		reset_tracking_in_scratch_org
	fi
	display_duration_of_script
	if [ "$shutdown" = true ]; then
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
	if [ "$use_git_status_mode" = false ]; then
		echo -e "\nRemoving content of metadata files that fail deployment :"
		if [ -d "${project_directory}connectedApps/" ]; then
			remove_consumer_key_on_each_connected_app
		fi
		if [ "$is_scratch_org" = "true" ]; then
			remove_users_from_queues
			if [ -d "${project_directory}sites/" ]; then
				remove_domain_on_each_site
			fi
			if [ -d "${project_directory}autoResponseRules/" ]; then
				replace_sender_email_in_case_autoresponse_rule
			fi
		fi
	fi
}

ctrl_c(){
	echo -ne "\n${RYellow}Aborting deployment... ${NC}"
	restore_edited_files
	sf project deploy cancel --use-most-recent > /dev/null
	exit 1
}

deploy_files_into_current_org(){
	get_additional_deploy_parameters

	local type_of_deploy="start"
	local start_phrase="Deploying"
	local success_phrase="Deployment"
	if [ "$validate" = true ]; then
		type_of_deploy="validate"
		start_phrase="Validating"
		success_phrase="Validation"
	fi

	if [[ "$full_deploy" = true ]]; then
		manifest_file="manifest/full.xml"
	else
		construct_deploy_package_xml
		manifest_file="deployPackage.xml"
	fi

	echo -e "\n${start_phrase} ${RBlue}project metadata files${NC} to org ${RPurple}${get_org_alias}${NC}... "
	local deploy_files_result=$(sf project deploy $type_of_deploy -x $manifest_file -w 600 --json$additional_deploy_parameters)
	local deployment_status=$(echo "$deploy_files_result" | jq -r '.status')
	if [ "$deployment_status" -eq 0 ]; then
		echo -e "${RGreen}${success_phrase} successful.${NC}"
		remove_files_created_by_script
		if [ "$current_branch" = "preprod" ] && [ -f "$config_file" ] && [ "$(yq eval '.deploy_settings.preprod // "null"' "$config_file")" != "null" ]; then
			sed -i -E "s|(preprod: ).*|\1\"$current_commit_hash_or_branch\"|" "$config_file"
		fi
	else
		echo -e "${RRed}Deployment failed. Fix the errors then relaunch the script.${NC}"
		local deployment_message=$(echo "$deploy_files_result" | jq -r '.message')
		if [[ -n "$deployment_message" && "$deployment_message" != "null" ]]; then
			echo -e "${RRed}Error: ${deployment_message}${NC}"
		fi
		if [ "$is_production_org" = "false" ]; then
			restore_edited_files
		fi
		display_duration_of_script
		if [ "$shutdown" = true ]; then
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

	if [ "$current_branch" = "preprod" ]; then
		current_commit_hash_or_branch=$(git rev-parse HEAD)
		commit_hash_or_branch_reference=$(yq eval '.deploy_settings.preprod' "$config_file")
		if [ -n "$commit_hash_or_branch_reference" ]; then
			echo -e "\nDeploying into preprod since commit : ${RGreen}${commit_hash_or_branch_reference}${NC}"
		else
			error_exit "You need to file the property .deploy_settings.preprod in the config file"
		fi
	else
		current_commit_hash_or_branch="$current_branch"
		commit_hash_or_branch_reference="master"
	fi

	add_option_to_delete_deleted_or_renamed_files

	if [ "$is_production_org" = "false" ]; then
		additional_deploy_parameters+=" --ignore-conflicts"
	fi

	if [[ "$is_production_org" = "true" || "$run_apex_tests" = true ]]; then
		if [ -n "$test_classes" ]; then
			additional_deploy_parameters+=" -t ${test_classes//,/ }"
		else
			additional_deploy_parameters+=" -l RunLocalTests"
		fi
	fi
}

add_option_to_delete_deleted_or_renamed_files(){
	echo -ne "\nChecking if files have been deleted from project... "

	local deleted_files=""
	if [ "$use_git_status_mode" = true ]; then
		deleted_files=$(git status --porcelain | awk '$1 == "D" && $2 ~ /-meta\.xml$/ && $2 ~ /^force-app\/main\/default\// {print $2}')
	else
		deleted_files=$(git diff --diff-filter=D --name-only ${commit_hash_or_branch_reference}...${current_commit_hash_or_branch} | awk '$1 ~ /-meta\.xml$/ && $1 ~ /^force-app\/main\/default\//')
	fi

	local renamed_files=$(find_deleted_files_in_renamed_files)
	local deleted_labels=$(find_deleted_labels)

	if [[ -n "$deleted_files" || -n "$renamed_files" || -n "$deleted_labels" ]]; then
		echo -n "Deleted files found."
		echo -ne "\nGenerating ${RCyan}postDeployDestructiveChanges.xml${NC} to perform deletion on post deployment... "
		local generated_xml=$(generate_package_xml "${deleted_files}\n${renamed_files}\n${deleted_labels}" true)
		if grep -q "Metadata type not found" <<< "$generated_xml"; then
			restore_edited_files_and_exit "$generated_xml"
		fi
		echo "$generated_xml" > postDeployDestructiveChanges.xml
		additional_deploy_parameters+=" --ignore-warnings --post-destructive-changes postDeployDestructiveChanges.xml"
		echo "Done."
	else
		echo "No deleted files found."
	fi
}

find_deleted_files_in_renamed_files(){
	local renamed_or_moved_files=""
	if [ "$use_git_status_mode" = true ]; then
		renamed_or_moved_files=$(git status --porcelain -z | tr '\0' '\n' | grep '^R' | awk '{print $2}' | grep -E '^-?force-app/.*-meta\.xml$')
	else
		renamed_or_moved_files=$(git diff --diff-filter=R --name-status ${commit_hash_or_branch_reference}...${current_commit_hash_or_branch} | \
			awk '$1 ~ /^R/ && $2 ~ /-meta.xml$/ && $2 ~ /^force-app\/main\/default\// {print $2}')
	fi

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
	local diff_output=""
	if [ "$use_git_status_mode" = true ]; then
		diff_output=$(git diff "${project_directory}labels/CustomLabels.labels-meta.xml")
	else
		diff_output=$(git diff ${commit_hash_or_branch_reference}...${current_commit_hash_or_branch} "${project_directory}labels/CustomLabels.labels-meta.xml")
	fi

	local removed_labels=$(echo "$diff_output" | grep -E '^-\s*<fullName>' | awk -F'[<>]' '/<fullName>/{gsub(/^ +/, ""); print $3}' | sed "s|^|${project_directory}label/|")

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

construct_deploy_package_xml(){
	local files_to_deploy=""

	if [ "$use_git_status_mode" = true ]; then
		files_to_deploy=$(git status --porcelain | \
			awk '$1 ~ /^(A|M|AM|MM|\?\?)/ {print $2}' | \
			grep -E '^force-app/' | xargs -0 printf "%b")
	else
		files_to_deploy=$(git diff --diff-filter=ARM --name-only ${commit_hash_or_branch_reference}...${current_commit_hash_or_branch} | \
			grep -E '^"?force-app/' | sed 's/^"\(.*\)"$/\1/' | xargs -0 printf "%b")
	fi

	if [[ -n "$files_to_deploy" ]]; then
		echo -ne "\nGenerating ${RCyan}deployPackage.xml${NC} to perform fast deployment..."
		local generated_xml=$(generate_package_xml "$files_to_deploy" false)
		if grep -q "Metadata type not found" <<< "$generated_xml"; then
			restore_edited_files_and_exit "$generated_xml"
		fi
		echo "$generated_xml" > deployPackage.xml
		echo "Done."
	else
		restore_edited_files_and_exit "There are no changes to deploy."
	fi
}

generate_package_xml(){
	local files_to_put_in_xml=$1
	local is_for_deletion=${2:-false}

	declare -A fileNames_by_metadata_type

	while IFS= read -r fileFullPath; do
		if [[ $fileFullPath == *${project_directory}* ]]; then
			local folder=$(echo "$fileFullPath" | awk -F '/' '{print $4}')

			if [ "$is_for_deletion" = true ]; then
				if [[ ! $fileFullPath =~ -meta\.xml$ ]]; then
					continue
				fi
				case $folder in
					"assignmentRules" | "audience" | "autoResponseRules" | "dashboards" | "documents" | "escalationRules" | "experiences" | "managedTopics" | "matchingRules" | "moderation" | "navigationMenus" | "networkBranding" | "networks" | "objectTranslations" | "profiles" | "reports" | "reportTypes" | "settings" | "sharingRules" | "siteDotComSites" | "sites" | "standardValueSets" | "territory2Models" | "territory2Types" | "translations" | "userCriteria" | "workflows")
						continue
						;;
				esac
			else
				case $folder in
					"connectedApps" | "profiles")
						continue
						;;
				esac
			fi

			local fileName=$(basename "$fileFullPath" | sed 's/\.[^.]*-meta\.xml$//')
			if [[ $folder = customMetadata ]]; then
				fileName=$(basename "$fileFullPath" | sed 's/\.md-meta\.xml$//')
			elif [[ $folder != quickActions ]]; then
				fileName=$(echo "$fileName" | cut -d. -f1)
			fi

			if [[ $folder = objects && $fileFullPath != *.object-meta.xml ]]; then
				local sobject=$(echo "$fileFullPath" | awk -F '/' '{print $5}')
				sub_folder=$(echo "$fileFullPath" | awk -F '/' '{print $6}')

				if [ "$is_for_deletion" = true ]; then
					case $sub_folder in
						"recordTypes")
							continue
							;;
					esac
				fi

				metadata_type=$(find_metadata_type_by_folder_name "$sub_folder")
				fileName="${sobject}.${fileName}"
			elif [[ ($folder = aura || $folder = lwc) && $fileFullPath != *.object-meta.xml ]]; then
				metadata_type=$(find_metadata_type_by_folder_name "$folder")
				local folderName=$(echo "$fileFullPath" | awk -F '/' '{print $5}')
				fileName="$folderName"
			elif [[ $folder = staticresources ]]; then
				metadata_type=$(find_metadata_type_by_folder_name "$folder")
				fileName=$(echo "$fileFullPath" | awk -F '/staticresources/' '{print $2}' | cut -d'/' -f1 | cut -d. -f1)
			elif [[ $folder = email ]]; then
				if [[ $fileFullPath =~ emailFolder-meta\.xml$ ]]; then
					metadata_type="EmailFolder"
				else
					metadata_type="EmailTemplate"
					fileName=$(echo "$fileFullPath" | awk -F '/email/' '{print $2}' | cut -d. -f1)
				fi
			elif [[ $folder = reports ]]; then
				if [[ $fileFullPath =~ reportFolder-meta\.xml$ ]]; then
					metadata_type="ReportFolder"
				else
					metadata_type="Report"
					fileName=$(echo "$fileFullPath" | awk -F '/reports/' '{print $2}' | cut -d. -f1)
				fi
			else
				metadata_type=$(find_metadata_type_by_folder_name "$folder")
			fi

			if [ -z "$metadata_type" ]; then
				metadata_type="Metadata type not found for folder '$folder$sub_folder'"
			fi

			if [[ "$metadata_type" == "CustomField" && ! "$fileName" =~ __c$ ]] || \
				{ [[ "$metadata_type" == "CustomObject" || "$metadata_type" == "CustomMetadata" ]] && \
					[[ "$fileName" =~ ^[a-zA-Z0-9]+__.+__c$ ]]; }; then
				continue
			fi

			escaped_fileName=$(printf '%s\n' "$fileName" | sed 's/[][\\.^$*+?{}|]/\\&/g')
			if [[ ! "${fileNames_by_metadata_type[$metadata_type]}" =~ (^|;)"$escaped_fileName"';' ]]; then
				fileNames_by_metadata_type["$metadata_type"]+="$fileName;"
			fi
		fi
	done <<< "$(echo -e "$files_to_put_in_xml")"

	# Generate XML package
	echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
	echo "<Package xmlns=\"${xml_namespace}\">"

	for metadata_type in $(echo "${!fileNames_by_metadata_type[@]}" | tr ' ' '\n' | sort); do
		echo -e "\t<types>"
		IFS=';' read -ra fileNames <<< "${fileNames_by_metadata_type[$metadata_type]}"
		for fileName in "${fileNames[@]}"; do
			echo -e "\t\t<members>$fileName</members>"
		done
		echo -e "\t\t<name>$metadata_type</name>"
		echo -e "\t</types>"
	done

	local version=$(jq -r '.sourceApiVersion' sfdx-project.json)
	echo -e "\t<version>65.0</version>"
	echo "</Package>"
}

remove_files_created_by_script(){
	rm -f "postDeployDestructiveChanges.xml"
	rm -f "deployPackage.xml"
}

deploy_territories_into_current_org(){
	echo -ne "\nDeploying ${RCyan}territories${NC} to org... "
	local deploy_territories_result=$(sf project deploy start -x manifest/territories.xml --ignore-conflicts --ignore-warnings --json)
	echo "Done."
}

restore_edited_files_and_exit(){
	local error_message=$1
	if [ "$is_production_org" = "false" ]; then
		restore_edited_files
	fi
	error_exit "$error_message"
}

restore_edited_files(){
	if [ "$use_git_status_mode" = false ]; then
		local modified_directories=("connectedApps")
		if [ "$is_scratch_org" = "true" ]; then
			modified_directories+=("queues" "autoResponseRules" "sites")
		fi
		for dir in "${modified_directories[@]}"; do
			git restore "${project_directory}${dir}" > /dev/null 2>&1
		done
	fi
}

store_last_deployed_commit_hash(){
	echo -ne "\nAdding last deployed commit hash to $config_file... "
	git fetch origin preprod > /dev/null 2>&1
	git pull origin preprod > /dev/null 2>&1
	git add "$config_file" > /dev/null 2>&1
	git commit -m "Updated last commit hash deployed in preprod" > /dev/null 2>&1 || true
	git push origin preprod > /dev/null 2>&1
	echo "Done."
}

reset_tracking_in_scratch_org(){
	echo -ne "Resetting ${RGreen}tracking${NC} on scratch org... "
	sf project reset tracking -p > /dev/null
	echo "Done."
}

main