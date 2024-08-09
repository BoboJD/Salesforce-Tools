#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"
. ./scripts/parameters.sh
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
	if [ "$check_windows_git_update" = "true" ]; then
		check_update_of_git
	fi
	if [ "$check_global_npm_packages_update" = "true" ]; then
		check_update_for_global_npm_packages
	fi
	check_org_type

	if [[ "$is_production_org" = "true" ]]; then
		if [ $current_branch = "master" ]; then
			git checkout -b admin master
		fi
		if [ "$check_npm_packages_update" = "true" ]; then
			update_npm_packages
		fi
	fi

	if [[ -z "$option" || "$option" = "-e" || "$option" = "--exclude-experiences" || "$option" = "-oc" || "$option" = "--only-configuration" ]]; then
		retrieve_configuration
	fi

	if [ "$territories_used" = "true" ]; then
		if [[ -z "$option" || "$option" = "-e" || "$option" = "--exclude-experiences" || "$option" = "-ot" || "$option" = "--only-territories" ]]; then
			retrieve_territories
		fi
	fi


	if [ "$experience_cloud_used" = "true" ]; then
		if [[ -z "$option" || "$option" = "-oe" || "$option" = "--only-experiences" ]]; then
			retrieve_experiences
		fi
	fi

	if [[ -z "$option" || "$option" = "-op" || "$option" = "--only-permissions" ]]; then
		retrieve_permissions
		retrieve_profiles
	fi

	if [[ "$is_production_org" = "true" && ( -z "$option" || "$option" = "-s" || "$option" = "--subtree" ) ]]; then
		if [ -z "$option" ]; then
			retrieve_development
			create_backup_of_conga_queries
			if [ "$org_shape_enable" = "true" ]; then
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
	echo -e "\nChecking if ${RBlue}npm packages${NC} have update... "
	update_info=$(ncu)
	if [[ $update_info == *"dependencies match the latest package versions"* ]]; then
		echo "All dependencies are up to date."
	else
		echo "Updates detected."
		ncu -u
		npm install --force
	fi
}

retrieve_configuration(){
	echo -e "\nRetrieving ${RCyan}configuration${NC}..."
	for dir in "${configuration_directories[@]}"; do
		rm -rf "${project_directory}${dir}"
	done
	sf project retrieve start -x manifest/configuration.xml --ignore-conflicts > /dev/null
	remove_traduction_of_weblinks
	remove_esconnect_rule_from_lead_matching_rules
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

remove_traduction_of_weblinks(){
	for file in ${project_directory}objectTranslations/*/*.objectTranslation-meta.xml; do
		xml ed -L -N x="$xml_namespace" -d "//x:webLinks[starts-with(x:name, \"pi__\")]" "$file"
		xml fo --indent-spaces 4 "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
	done
}

remove_esconnect_rule_from_lead_matching_rules(){
	lead_matching_rule_file="${project_directory}matchingRules/Lead.matchingRule-meta.xml";
	xml ed -L -N x="$xml_namespace" -d "//x:matchingRules[starts-with(x:fullName, \"ESCONNECT__Ellisphere_SIRET\")]" "${lead_matching_rule_file}"
	xml fo --indent-spaces 4 "$lead_matching_rule_file" > "${lead_matching_rule_file}.tmp" && mv "${lead_matching_rule_file}.tmp" "$lead_matching_rule_file"
}

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
	git restore ${project_directory}siteDotComSites/Engie1.site
	git restore ${project_directory}siteDotComSites/Gazel1.site
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
		if [ "${#unused_standard_layouts[@]}" -gt 0 ]; then
			for unused_layout in "${unused_standard_layouts[@]}"; do
				xml ed -L -N x="$xml_namespace" -d "//x:layoutAssignments[starts-with(x:layout, \"${unused_layout}-\")]" "$profile"
			done
		fi
		if [ "${#user_permissions_to_delete[@]}" -gt 0 ]; then
			for user_permission_name in "${user_permissions_to_delete[@]}"; do
				xml ed -L -N x="$xml_namespace" -d "//x:userPermissions[x:name = \"$user_permission_name\"]" "$profile"
			done
		fi
		if [ "${#unnecessary_permissions_to_delete[@]}" -gt 0 ]; then
			for unnecessary_permission in "${unnecessary_permissions_to_delete[@]}"; do
				xml ed -L -N x="$xml_namespace" -d "//*/x:$unnecessary_permission" "$profile"
			done
		fi
		xml fo --indent-spaces 4 "$profile" > "${profile}.tmp" && mv "${profile}.tmp" "$profile"
	done
	echo "Done."
}

retrieve_development(){
	echo -e "\nRetrieving ${RBlue}development${NC}..."
	sf project retrieve start -m ApexClass ApexTrigger ApexPage ApexComponent LightningComponentBundle AuraDefinitionBundle --ignore-conflicts > /dev/null
}

create_backup_of_conga_queries(){
	echo -e "\nCreating backup of ${RBlue}conga queries${NC}..."
	sf data export tree --query "SELECT Id, Alias__c, APXTConga4__Description__c, APXTConga4__Key__c, APXTConga4__Name__c, APXTConga4__Query__c, Name, Objets__c FROM APXTConga4__Conga_Merge_Query__c ORDER BY Name" --output-dir data
}

recreate_org_shape(){
	echo -e "\nRecreating ${RGreen}org shape${NC}..."
	sf org create shape -o $devhub_name
}

check_installed_managed_packages_version(){
	if is_array_with_elements "appexchange_installation_order"; then
		echo -e "\nChecking if ${RBlue}managed packages${NC} have been updated :"
		installed_packages=$(sf package installed list --json)
		for appexchange_name in "${appexchange_installation_order[@]}"; do
			appexchange_id="${appexchange_id_by_name[$appexchange_name]}"
			check_package_version "$appexchange_id" "$appexchange_name"
		done
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
			sed -i "s/${package_id}/${new_package_id}/g" "./scripts/parameters.sh"
			echo -e "${RGreen}Package version id updated.${NC}"
		else
			error_exit "Package not found"
		fi
	fi
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
		git restore "${project_directory}${dir}" > /dev/null
	done
}

main