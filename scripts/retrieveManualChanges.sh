#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"
current_branch=$(git symbolic-ref --short HEAD)

# Parameters (not mandatory)
# -e / --exclude-experiences : doesn't retrieve experience files
# -oc / --only-configuration : only retrieve configuration files
# -oe / --only-experiences : only retrieve experience files
# -op / --only-permissions : only retrieve permission files
# -s / --subtree : only pull subtree changes
option=$1

main(){
	display_start_time
	check_update_of_git
	check_update_for_global_npm_packages
	check_org_type

	if [[ "$is_production_org" = "true" ]]; then
		if [ $current_branch = "master" ]; then
			git checkout -b admin master
		fi
		update_npm_packages
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

	if [[ "$is_production_org" = "true" && ( -z "$option" || "$option" = "-s" || "$option" = "--subtree" ) ]]; then
		if [ -z "$option" ]; then
			retrieve_development
			if [[ $(yq eval '.data_backup // "null"' "$config_file") != "null" ]]; then
				create_backup_of_data
			fi
			if [[ $(yq eval '.org_settings.org_shape_enable // "null"' "$config_file") = "true" ]]; then
				recreate_org_shape
			fi
		fi
		check_installed_managed_packages_version
		updating_salesforce_tools_subtree
	fi

	remove_ignored_files

	if [ "$is_scratch_org" = "true" ]; then
		restore_files_modified_by_scratch_org
	fi

	display_duration_of_script
}

check_org_type(){
	echo -ne "\nChecking org type... "
	is_production_org=$(check_production_org)
	is_scratch_org=$(check_scratch_org)
	echo "Done."
}

update_npm_packages(){
	if [[ $(yq eval '.features.auto_update_settings.check_npm_packages_update // "null"' "$config_file") = "true" ]]; then
		echo -e "\nChecking if ${RBlue}npm packages${NC} have update... "
		update_info=$(ncu)
		if [[ $update_info == *"dependencies match the latest package versions"* ]]; then
			echo "All dependencies are up to date."
		else
			echo "Updates detected."
			ncu -u
			npm install --force
		fi
	fi
}

retrieve_configuration(){
	echo -e "\nRetrieving ${RCyan}configuration${NC}..."
	for dir in "${configuration_directories[@]}"; do
		rm -rf "${project_directory}${dir}"
	done
	sf project retrieve start -x manifest/configuration.xml --ignore-conflicts > /dev/null
	if [ -d "${project_directory}translations" ]; then
		remove_untracked_xml_blocks_in_translations
	fi
}

remove_untracked_xml_blocks_in_translations(){
	for translation in ${project_directory}translations/*.translation-meta.xml; do
		sed -n -i '/<customApplications>/,/<\/customApplications>/!p' "$translation"
		sed -n -i '/<customPageWebLinks>/,/<\/customPageWebLinks>/!p' "$translation"
		sed -n -i '/<customTabs>/,/<\/customTabs>/!p' "$translation"
		sed -n -i '/<prompts>/,/<\/prompts>/!p' "$translation"
		sed -n -i '/<reportTypes>/,/<\/reportTypes>/!p' "$translation"
		sed -i "/<label><!-- Conga Composer (Deprecated) --><\/label>/{$d;N;N;N;d};P;D" "$translation"
		sed -i "/<label><!-- Conga Composer SF1 EU --><\/label>/{$d;N;N;N;d};P;D" "$translation"
		sed -i "/<label><!-- Conga Composer --><\/label>/{$d;N;N;N;d};P;D" "$translation"
	done
}

configuration_directories=(
	"animationRules"
	"applications"
	"assignmentRules"
	"autoResponseRules"
	"cachePartitions"
	"callCenters"
	"contentassets"
	"corsWhitelistOrigins"
	"cspTrustedSites"
	"customMetadata"
	"documents"
	"email"
	"escalationRules"
	"flexipages"
	"flows"
	"globalValueSets"
	"groups"
	"labels"
	"layouts"
	"LeadConvertSettings"
	"letterhead"
	"matchingRules"
	"notificationTypes"
	"objects"
	"objectTranslations"
	"pathAssistants"
	"queues"
	"quickActions"
	"remoteSiteSettings"
	"reports"
	"reportTypes"
	"roles"
	"sharingRules"
	"standardValueSets"
	"staticresources"
	"tabs"
	"workflows"
)

retrieve_territories(){
	echo -e "\nRetrieving ${RYellow}territories${NC}..."
	for dir in "${territories_directories[@]}"; do
		rm -rf "${project_directory}${dir}"
	done
	sf project retrieve start -x manifest/territories.xml --ignore-conflicts > /dev/null
}

territories_directories=(
	"territory2Models"
	"territory2Types"
)

retrieve_experiences(){
	echo -e "\nRetrieving ${RGreen}experiences${NC}..."
	for dir in "${experiences_directories[@]}"; do
		rm -rf "${project_directory}${dir}"
	done
	sf project retrieve start -x manifest/communities.xml --ignore-conflicts > /dev/null
	for file in ${project_directory}siteDotComSites/*; do
		git restore "$file" > /dev/null 2>&1
	done
}

experiences_directories=(
	"audience"
	"experiences"
	"managedTopics"
	"moderation"
	"navigationMenus"
	"networkBranding"
	"networks"
	"sites"
	"siteDotComSites"
	"userCriteria"
)

retrieve_permissions(){
	echo -e "\nRetrieving ${RRed}permissions${NC}..."
	for dir in "${permissions_directories[@]}"; do
		rm -rf "${project_directory}${dir}"
	done
	sf project retrieve start -x manifest/permissions.xml --ignore-conflicts > /dev/null
}

permissions_directories=(
	"customPermissions"
	"permissionsetgroups"
	"permissionsets"
)

retrieve_profiles(){
	echo -e "\nRetrieving ${RPurple}profiles${NC}..."
	mv .forceignore .DISABLED.forceignore
	sf project retrieve start -x manifest/profiles.xml --ignore-conflicts > /dev/null
	mv .DISABLED.forceignore .forceignore

	echo -ne "Removing unnecessary permissions... "
	for profile in ${project_directory}profiles/*.profile-meta.xml; do
		if [[ $(yq eval '.unused_standard_layouts // "null"' "$config_file") != "null" ]]; then
			while IFS= read -r unused_layout; do
				xml ed -L -N x="$xml_namespace" -d "//x:layoutAssignments[starts-with(x:layout, \"${unused_layout}-\")]" "$profile"
			done < <(yq eval '.unused_standard_layouts[]' "$config_file")
		fi
		if [[ $(yq eval '.user_permissions_to_delete // "null"' "$config_file") != "null" ]]; then
			while IFS= read -r user_permission_name; do
				xml ed -L -N x="$xml_namespace" -d "//x:userPermissions[x:name = \"$user_permission_name\"]" "$profile"
			done < <(yq eval '.user_permissions_to_delete[]' "$config_file")
		fi
		if [[ $(yq eval '.unnecessary_permissions_to_delete // "null"' "$config_file") != "null" ]]; then
			while IFS= read -r unnecessary_permission; do
				xml ed -L -N x="$xml_namespace" -d "//*/x:$unnecessary_permission" "$profile"
			done < <(yq eval '.unnecessary_permissions_to_delete[]' "$config_file")
		fi
		xml fo --indent-spaces 4 "$profile" > "${profile}.tmp" && mv "${profile}.tmp" "$profile"
	done
	echo "Done."
}

retrieve_development(){
	echo -e "\nRetrieving ${RBlue}development${NC}..."
	sf project retrieve start -m ApexClass ApexTrigger ApexPage ApexComponent LightningComponentBundle AuraDefinitionBundle --ignore-conflicts > /dev/null
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

check_installed_managed_packages_version(){
	if [[ $(yq eval '.scratch_org_settings.appexchange.appexchange_id_by_name // "null"' "$config_file") != "null" ]]; then
		echo -e "\nChecking if ${RBlue}managed packages${NC} have been updated :"
		declare -A appexchange_id_by_name
		parse_yaml_to_assoc_array "$config_file" '.scratch_org_settings.appexchange.appexchange_id_by_name' appexchange_id_by_name
		local installed_packages=$(sf package installed list --json)
		while IFS= read -r appexchange_name; do
			local appexchange_id="${appexchange_id_by_name[$appexchange_name]}"
			check_package_version "$appexchange_id" "$appexchange_name"
		done < <(yq eval '.scratch_org_settings.appexchange.appexchange_id_by_name | keys | .[]' "$config_file")
	fi
}

check_package_version(){
	local package_id=$1
	local package_name=$2

	echo -ne "- Verifying package version id of ${RCyan}${package_name}${NC}... "
	local package_installed=$(echo "$installed_packages" | jq ".result[] | select(.SubscriberPackageVersionId == \"$package_id\")")

	if [ -n "$package_installed" ]; then
		echo -e "${RYellow}Already up-to-date.${NC}"
	else
		local new_package_id=$(echo "$installed_packages" | jq -r ".result[] | select(.SubscriberPackageName == \"$package_name\") | .SubscriberPackageVersionId")
		if [ -n "$new_package_id" ]; then
			sed -i '/^$/s// #BLANK_LINE/' "$config_file"
			yq eval -i ".scratch_org_settings.appexchange.appexchange_id_by_name.\"$package_name\" = \"$new_package_id\"" "$config_file"
			sed -i "s/ *#BLANK_LINE//g" "$config_file"
			echo -e "${RGreen}Package version id updated.${NC}"
		else
			error_exit "Package not found"
		fi
	fi
}

updating_salesforce_tools_subtree(){
	local PREFIX="tlz"
	local REPO="git@github.com:BoboJD/Salesforce-Tools.git"
	local BRANCH="master"
	echo -ne "\nFetching ${RGreen}Salesforce-Tools${NC} subtree... "
	git fetch $REPO $BRANCH > /dev/null 2>&1
	local SUBTREE_LATEST=$(git log -n 1 --pretty=format:%H -- "$PREFIX")
	if ! git diff --quiet FETCH_HEAD $SUBTREE_LATEST; then
		echo -n "Subtree has changed. Pulling the latest changes... "
		git stash push -m "Stashing before subtree pull" > /dev/null 2>&1
		git subtree pull --prefix="$PREFIX" "$REPO" "$BRANCH" -m "Merge subtree" > /dev/null 2>&1
		git stash pop > /dev/null 2>&1
	fi
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

main