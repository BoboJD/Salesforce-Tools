#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"
current_branch=$(git symbolic-ref --short HEAD)

if [ $current_branch = "master" ]; then
	git checkout -b admin master > /dev/null 2>&1
fi

if [ $current_branch = "prod-release" ]; then
	error_exit "Script cannot be run from prod-release"
fi

# Parameters (not mandatory)
# -e / --exclude-experiences : doesn't retrieve experience files
# -oc / --only-configuration : only retrieve configuration files
# -od / --only-development : only retrieve development files
# -oe / --only-experiences : only retrieve experience files
# -op / --only-permissions : only retrieve permission files
# -trad : only retrieve translation files
# -s / --subtree : only pull subtree & packages changes
option=$1

USER_PERMISSIONS_TO_DELETE=(
    "TraceXdsQueries"
    "AllowObjectDetectionTraining"
    "ModifyAllPolicyCenterPolicies"
    "UserInteractionInsights"
    "ViewAllPolicyCenterPolicies"
)

main(){
	display_start_time
	check_update_of_git
	check_update_for_global_npm_packages
	check_org_type

	if [[ "$is_production_org" = "true" && ( -z "$option" || "$option" = "-s" || "$option" = "--subtree" ) ]]; then
		updating_salesforce_tools
		if [ -z "$option" ]; then
			update_npm_packages
			if [[ $(yq eval '.data_backup // "null"' "$config_file") != "null" ]]; then
				create_backup_of_data
			fi
			if [[ $(yq eval '.org_settings.org_shape_enable // "null"' "$config_file") = "true" ]]; then
				recreate_org_shape
			fi
		fi
	fi

	if [[ ("$is_production_org" = "true" || $(yq eval '.features.always_retrieve_development // "null"' "$config_file") = "true") && ( -z "$option" || "$option" = "-od" || "$option" = "----only-development" ) ]]; then
		retrieve_development
	fi

	if [[ -z "$option" || "$option" = "-e" || "$option" = "--exclude-experiences" || "$option" = "-oc" || "$option" = "--only-configuration" ]]; then
		retrieve_configuration
	fi

	if [[ $(yq eval '.org_settings.territories_used // "null"' "$config_file") = "true" ]]; then
		if [[ -z "$option" || "$option" = "-e" || "$option" = "--exclude-experiences" || "$option" = "-ot" || "$option" = "--only-territories" ]]; then
			retrieve_territories
		fi
	fi

	if [[ $(yq eval '.org_settings.experience_cloud_used // "null"' "$config_file") = "true" ]]; then
		if [[ -z "$option" || "$option" = "-oe" || "$option" = "--only-experiences" ]]; then
			retrieve_experiences
		fi
	fi

	if [[ -z "$option" || "$option" = "-op" || "$option" = "--only-permissions" ]]; then
		retrieve_permissions
		if [[ $(yq eval '.org_settings.profile_used // "null"' "$config_file") = "true" ]]; then
			retrieve_profiles
		fi
	fi

	remove_ignored_files

	if [ "$is_scratch_org" = "true" ]; then
		restore_files_modified_by_scratch_org
	fi

	cleanup_branch_if_no_changes
	display_duration_of_script
}

check_org_type(){
	echo -ne "\nChecking org type... "
	is_production_org=$(check_production_org)
	is_scratch_org=$(check_scratch_org)
	echo "Done."
}

updating_salesforce_tools() {
	echo -ne "\nPulling ${RBlue}Salesforce Tools${NC} new commits... "
	git fetch "git@github.com:BoboJD/Salesforce-Tools.git" "master" > /dev/null 2>&1
	git subtree pull --prefix="tlz" "git@github.com:BoboJD/Salesforce-Tools.git" "master" -m "Pulled Salesforce Tools new commits" --squash > /dev/null 2>&1
	echo "Done."

	if [[ $(yq eval '.org_settings.packages // "null"' "$config_file") != "null" ]]; then
		if yq eval '.org_settings.packages[]' "$config_file" | grep -Fxq "Salesforce Tools"; then
			check_installation_of_salesforce_tools
		fi
	fi
}

check_installation_of_salesforce_tools() {
	echo -ne "Verifying installed version of ${RCyan}Salesforce Tools${NC}... "
	local installed_packages=$(sf package installed list --json 2>/dev/null)
	local installed_package_id=$(echo "$installed_packages" | jq -r '.result[] | select(.SubscriberPackageName == "Salesforce Tools") | .SubscriberPackageVersionId')
	if [[ -z "$installed_package_id" || "$installed_package_id" == "null" ]]; then
		echo -e "${RYellow}Not installed.${NC}"
		installed_package_id=""
	fi

	local package_id=$(jq -r '.packageAliases | to_entries | map(select(.key | startswith("Salesforce Tools"))) | last | .value' tlz/sfdx-project.json)
	if [[ -z "$package_id" || "$package_id" == "null" ]]; then
		error_exit "No valid package ID found in tlz/sfdx-project.json."
	fi

	if [[ "$installed_package_id" == "$package_id" ]]; then
		echo -e "${RYellow}Already up-to-date.${NC}"
	else
		echo "Latest version not installed, starting installation..."
		local install_result=$(sf package install -p "$package_id" -w 60 -r --json 2>/dev/null)
		local install_status=$(echo "$install_result" | jq -r '.status')
		if [[ "$install_status" -eq 0 ]]; then
			sf project deploy start -m "Layout:tlz__OrgSetting__mdt-tlz__OrgSetting Layout" "Layout:tlz__Setting__c-tlz__Setting Layout" --ignore-conflicts --ignore-warnings --json > /dev/null
			echo -e "${RGreen}Package version updated.${NC}"
		else
			local msg=$(echo "$install_result" | jq -r '.message // .result.errors[]?.message // "Unknown error"')
			error_exit "Package installation failed: $msg"
		fi
	fi
}

update_npm_packages(){
	if [[ $(yq eval '.features.auto_update_settings.check_npm_packages_update // "null"' "$config_file") = "true" ]]; then
		echo -ne "\nChecking if ${RBlue}npm packages${NC} have update... "
		ncu --upgrade --silent
		if git diff --quiet package.json; then
			echo -e "${RYellow}All dependencies are up to date.${NC}"
		else
			echo "Updates detected in package.json, starting installation..."
			npm install --force --loglevel=error
		fi
	fi
}

create_backup_of_data(){
	echo -e "\nCreating backup of ${RBlue}data${NC}..."
	while IFS= read -r soql; do
		sf data export tree --query "$soql" --output-dir data
	done < <(yq eval '.data_backup[]' "$config_file")
}

recreate_org_shape(){
	echo -e "\nRecreating ${RGreen}org shape${NC}..."
	local devhub_name=$(yq eval '.org_settings.devhub_name' "$config_file")
	sf org create shape -o $devhub_name
}

retrieve_development(){
	echo -e "\nRetrieving ${RBlue}development${NC}..."
	sf project retrieve start -m ApexClass ApexTrigger ApexPage ApexComponent LightningComponentBundle AuraDefinitionBundle --ignore-conflicts > /dev/null
}

retrieve_configuration(){
	echo -e "\nRetrieving ${RCyan}configuration${NC}..."
	retrieve "configuration"
	if [[ $(yq eval '.translation_settings // "null"' "$config_file") != "null" ]]; then
		remove_untracked_xml_blocks_in_translations
	fi
}

retrieve(){
	local xml_name="$1"
	local xml_path="manifest/${xml_name}.xml"
	if [[ ! -f "$xml_path" ]]; then
		error_exit "Error: File '$xml_path' is missing. Please create the file and try again."
	fi
	delete_folders "$xml_path"
	sf project retrieve start -x "$xml_path" --ignore-conflicts > /dev/null
}

retrieve_territories(){
	echo -e "\nRetrieving ${RYellow}territories${NC}..."
	retrieve "territories"
}

retrieve_experiences(){
	echo -e "\nRetrieving ${RGreen}experiences${NC}..."
	retrieve "communities"
	for file in ${project_directory}siteDotComSites/*; do
		git restore "$file" > /dev/null 2>&1
	done
}

remove_untracked_xml_blocks_in_translations(){
	if [[ $(yq eval '.translation_settings.sobjects // "null"' "$config_file") != "null" ]]; then
		for folder in ${project_directory}objectTranslations/*; do
			if [ -d "$folder" ]; then
				local sobject=$(basename "$folder" | cut -d'-' -f1)
				if [[ $(yq eval ".translation_settings.sobjects.$sobject // \"null\"" "$config_file") != "null" ]]; then
					for objectTranslation in ${folder}/*.objectTranslation-meta.xml; do
						remove_untracked_layouts "$sobject" "$objectTranslation"
						remove_untracked_quickActions "$sobject" "$objectTranslation"
						indent "$objectTranslation"
					done
				fi
			fi
		done
	fi
	if [ -d "${project_directory}translations" ]; then
		for translation in ${project_directory}translations/*.translation-meta.xml; do
			remove_untracked_xml_tags "$translation"
			remove_untracked_globalQuickActions "$translation"
			remove_untracked_flowDefinitions "$translation"
			indent "$translation"
		done
	fi
}

remove_untracked_layouts(){
	local sobject=$1
	local file_path=$2
	if [[ $(yq eval ".translation_settings.sobjects.${sobject}.layouts // \"null\"" "$config_file") != "null" ]]; then
		while IFS= read -r layout_to_remove; do
			xml ed -L -N x="$xml_namespace" -d "//x:layouts[x:layout = \"$layout_to_remove\"]" "$file_path"
		done < <(yq eval ".translation_settings.sobjects.${sobject}.layouts[]" "$config_file")
	fi
}

remove_untracked_quickActions(){
	local sobject=$1
	local file_path=$2
	if [[ $(yq eval ".translation_settings.sobjects.${sobject}.quickActions // \"null\"" "$config_file") != "null" ]]; then
		while IFS= read -r action_to_remove; do
			xml ed -L -N x="$xml_namespace" -d "//x:quickActions[starts-with(x:name, \"$action_to_remove\")]" "$file_path"
		done < <(yq eval ".translation_settings.sobjects.${sobject}.quickActions[]" "$config_file")
	fi
}

remove_untracked_xml_tags(){
	local file_path=$1
	if [[ $(yq eval '.translation_settings.untracked // "null"' "$config_file") != "null" ]]; then
		while IFS= read -r untracked; do
			xml ed -L -N x="$xml_namespace" -d "//x:$untracked" "$translation"
		done < <(yq eval '.translation_settings.untracked[]' "$config_file")
	fi
}

remove_untracked_globalQuickActions(){
	local file_path=$1
	if [[ $(yq eval '.translation_settings.globalQuickActions // "null"' "$config_file") != "null" ]]; then
		while IFS= read -r action_to_remove; do
			xml ed -L -N x="$xml_namespace" -d "//x:globalQuickActions[starts-with(x:name, \"$action_to_remove\")]" "$file_path"
		done < <(yq eval '.translation_settings.globalQuickActions[]' "$config_file")
	fi
}

remove_untracked_flowDefinitions(){
	local file_path=$1
	if [[ $(yq eval '.translation_settings.flowDefinitions // "null"' "$config_file") != "null" ]]; then
		while IFS= read -r flow_to_remove; do
			xml ed -L -N x="$xml_namespace" -d "//x:flowDefinitions[starts-with(x:fullName, \"$flow_to_remove\")]" "$file_path"
		done < <(yq eval '.translation_settings.flowDefinitions[]' "$config_file")
	fi
}

indent(){
	local file_path=$1
	xml fo --indent-spaces 4 "$file_path" > "${file_path}.tmp" && mv "${file_path}.tmp" "$file_path"
}

retrieve_permissions(){
	echo -e "\nRetrieving ${RRed}permissions${NC}..."
	retrieve "permissions"
	remove_unnecessary_permissions_in_permissionsets
}

remove_unnecessary_permissions_in_permissionsets() {
    echo "Checking permission sets for ViewAllData..."

    shopt -s nullglob
    for ps_file in "${project_directory}permissionsets/"*.permissionset-meta.xml; do
        if xml sel \
            -N x="$xml_namespace" \
            -t -c "//x:userPermissions[x:enabled='true' and x:name='ViewAllData']" \
            "$ps_file" | grep -q .; then
            echo -ne "Removing unnecessary permissions in $(basename "$ps_file")... "
            xml ed -L \
                -N x="$xml_namespace" \
                -d "//*/x:objectPermissions" \
                "$ps_file"
            echo "Done."
        fi
    done
    shopt -u nullglob
}

retrieve_profiles(){
	echo -e "\nRetrieving ${RPurple}profiles${NC}..."
	mv .forceignore .DISABLED.forceignore
	retrieve "profiles"
	mv .DISABLED.forceignore .forceignore
	remove_unnecessary_permissions_in_profiles
}

remove_unnecessary_permissions_in_profiles(){
	echo -ne "Removing unnecessary permissions... "
	git clean -f -X "${project_directory}layouts/" > /dev/null
	existing_layouts=$(find "${project_directory}layouts/" -type f -name "*.layout-meta.xml" | sed -E 's|.*/||; s/\.layout-meta\.xml$//' | sed 's/-.*//' | sort -u)
	for profile in ${project_directory}profiles/*.profile-meta.xml; do
		while IFS= read -r layout_assignment; do
			base_layout=$(echo "$layout_assignment" | cut -d'-' -f1)
			if ! echo "$existing_layouts" | grep -qx "$base_layout"; then
				xml ed -L -N x="$xml_namespace" -d "//x:layoutAssignments[starts-with(x:layout, \"${base_layout}-\")]" "$profile"
			fi
		done < <(xml sel -N x="$xml_namespace" -t -m "//x:layoutAssignments/x:layout" -v . -n "$profile")
		for user_permission_name in "${USER_PERMISSIONS_TO_DELETE[@]}"; do
			xml ed -L -N x="$xml_namespace" \
				-d "//x:userPermissions[x:name = \"$user_permission_name\"]" \
				"$profile"
		done
		if [[ $(yq eval '.profile_settings.user_permissions_to_delete // "null"' "$config_file") != "null" ]]; then
			while IFS= read -r user_permission_name; do
				xml ed -L -N x="$xml_namespace" -d "//x:userPermissions[x:name = \"$user_permission_name\"]" "$profile"
			done < <(yq eval '.profile_settings.user_permissions_to_delete[]' "$config_file")
		fi
		if [[ $(yq eval '.profile_settings.unnecessary_permissions_to_delete // "null"' "$config_file") != "null" ]]; then
			while IFS= read -r unnecessary_permission; do
				xml ed -L -N x="$xml_namespace" -d "//*/x:$unnecessary_permission" "$profile"
			done < <(yq eval '.profile_settings.unnecessary_permissions_to_delete[]' "$config_file")
		fi
		indent "$profile"
	done
	echo "Done."
}

remove_ignored_files(){
	echo -ne "\nRemoving ${RCyan}ignored${NC} files..."
	git clean -dfX $project_directory > /dev/null
	git clean -dffX $project_directory > /dev/null
	git add . > /dev/null
	git reset > /dev/null
	echo " Done."
}

restore_files_modified_by_scratch_org(){
	local files_modified_by_scratch_org=(
		"assignmentRules"
		"autoResponseRules"
		"connectedApps"
		"queues"
		"settings"
		"sites"
		"standardValueSets"
	)
	for dir in "${files_modified_by_scratch_org[@]}"; do
		git restore "${project_directory}${dir}" > /dev/null 2>&1
	done
}

cleanup_branch_if_no_changes(){
	if git diff --quiet master HEAD && git diff --cached --quiet; then
		echo -e "\n${RYellow}Warning: No changes have been retrieved.${NC}"
		local branch_to_delete=$(git symbolic-ref --short HEAD)
		if [[ "$branch_to_delete" = "admin" || "$branch_to_delete" = "hotfix" ]]; then
			git checkout master > /dev/null 2>&1
			# Delete local branch only if it hasn't been pushed to remote
			if ! git ls-remote --heads origin "$branch_to_delete" | grep -q "$branch_to_delete"; then
				git branch -d "$branch_to_delete" > /dev/null 2>&1
			fi
		fi
	fi
}

main