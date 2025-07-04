#!/bin/bash
SECONDS=0
. "$SCRIPT_DIR/colors.sh"

# Set default properties
config_file="./config/salesforce-tools-config.yml"
xml_namespace="http://soap.sforce.com/2006/04/metadata"
project_path=$(jq -r '.packageDirectories[0].path // "force-app"' sfdx-project.json)
project_directory="$project_path/main/default/"
if [[ $(yq eval '.project.directory // "null"' "$config_file") != "null" ]]; then
	project_directory=$(yq eval '.project.directory' "$config_file")
fi

# Common methods
## error_exit
error_exit(){
	echo -e "${RRed}Error: $*${NC}"
	display_duration_of_script
	exit 1
}

## is_array_with_elements
is_array_with_elements(){
	local var_name="$1"
	if declare -p "$var_name" 2>/dev/null | grep -q 'declare -a'; then
		local array_length=$(eval "echo \${#$var_name[@]}")
		if [ "$array_length" -gt 0 ]; then
			return 0 # Array exists and has elements
		else
			return 1 # Array exists but is empty
		fi
	else
		return 1 # Not an array
	fi
}

# Function to parse YAML and create an associative array
## parse_yaml_to_assoc_array
parse_yaml_to_assoc_array(){
	local yaml_file="$1"
	local yaml_path="$2"
	declare -n assoc_array="$3"
	local yaml_entries=$(yq eval "$yaml_path | to_entries | .[]" "$yaml_file")
	local key
	local value
	while IFS= read -r entry; do
		if [[ $entry == key:* ]]; then
			key=$(echo "$entry" | sed -n 's/^key: "\(.*\)"/\1/p')
		elif [[ $entry == value:* ]]; then
			value=$(echo "$entry" | sed -n 's/^value: "\(.*\)"/\1/p')
			if [[ -n $key && -n $value ]]; then
				assoc_array["$key"]="$value"
				key=""
				value=""
			fi
		fi
	done <<< "$yaml_entries"
}

# Manage duration of scripts
## display_start_time
display_start_time(){
	local start_time=$(date +"%Hh%M")
	echo -e "Script started at ${RGreen}${start_time}${NC}\n"
	check_if_necessary_commands_are_available
}

## check_if_necessary_commands_are_available
check_if_necessary_commands_are_available(){
	command -v sf >/dev/null 2>&1 || error_exit "sf CLI is not installed."
	command -v jq >/dev/null 2>&1 || error_exit "jq is not installed."
	command -v yq >/dev/null 2>&1 || error_exit "yq is not installed."
	command -v xml >/dev/null 2>&1 || error_exit "XMLStarlet is not installed."
}

## display_duration_of_script
display_duration_of_script(){
	local duration=$SECONDS

	local end_time=$(date +"%Hh%M")
	echo -ne "\nScript has finished at ${RGreen}${end_time}${NC}. Duration of script: ${RGreen}"

	local hours=$(($duration / 3600))
	local minutes=$((($duration % 3600) / 60))
	local seconds=$(($duration % 60))

	if [ $hours -gt 0 ]; then
		echo -n "${hours}h "
	fi

	echo -e "${minutes}min ${seconds}sec${NC}"
}

# Methods to update cli if enabled in salesforce-tools-config.yml and used in scripts
## check_update_of_git
check_update_of_git(){
	if [[ $(yq eval '.features.auto_update_settings.check_windows_git_update // "null"' "$config_file") = "true" ]]; then
		echo -e "Checking if ${RBlue}git${NC} has update available..."
		git update-git-for-windows
	fi
}

## check_update_for_global_npm_packages
check_update_for_global_npm_packages(){
	if [[ $(yq eval '.features.auto_update_settings.check_global_npm_packages_update // "null"' "$config_file") = "true" ]]; then
		command -v ncu >/dev/null 2>&1 || error_exit "ncu (npm-check-updates) is not installed."
		echo -e "\nChecking if ${RBlue}global npm packages${NC} have updates available..."
		ncu_output=$(ncu -g)
		if [[ $ncu_output == *"All global packages are up-to-date"* ]]; then
			echo "All global npm packages are up-to-date."
		else
			upgrade_command=$(echo "$ncu_output" | grep -o 'npm -g install .*')
			if [ -n "$upgrade_command" ]; then
				echo -e "Updates detected, running : ${RBlue}$upgrade_command${NC}"
				eval "$upgrade_command"
				sf autocomplete --refresh-cache
			else
				error_exit "Error extracting upgrade command of 'ncu -g'."
			fi
		fi
	fi
}

# Org information methods
## get_org_details
get_org_details() {
	if [ -z "$org_details" ]; then
		org_details=$(sf org display --json | tr -d '\r')
	fi
}

## get_org_alias
get_org_alias(){
	get_org_details
	echo $(echo "$org_details" | jq -r '.result.alias')
}

## check_production_org
check_production_org(){
	get_org_details
	local org_id=$(echo "$org_details" | jq -r '.result.id')
	local production_org_id=$(yq eval '.org_settings.production_org_id' "$config_file")
	[ "$org_id" = "$production_org_id" ] && echo "true" || echo "false"
}

## check_if_org_is_of_type
check_if_org_is_of_type() {
	local type="$1"
	get_org_details
	local contains_type=$(echo "$org_details" | jq -r ".result.instanceUrl | test(\"\\\\.${type}\\\\.\")")
	[ "$contains_type" = "true" ] && echo "true" || echo "false"
}

## check_scratch_org
check_scratch_org() {
  	check_if_org_is_of_type "scratch"
}

## check_sandbox_org
check_sandbox_org() {
  	check_if_org_is_of_type "sandbox"
}

# Methods to handle metadata in script
## delete_folders
delete_folders(){
	local xml_file="$1"
	while read -r metadata_type; do
		metadata_type=$(echo "$metadata_type" | xargs)
		folder=$(find_folder_name_by_metadata_type "$metadata_type")
		if [ -n "$folder" ]; then
			rm -rf "${project_directory}${folder}"
		fi
	done < <(xml sel -t -m "//*[local-name()='name']" -v . -n "$xml_file")
}

## find_metadata_type_by_folder_name
find_metadata_type_by_folder_name(){
	local folder="$1"
	declare -A folder_to_type_mapping
	folder_to_type_mapping=(
		["animationRules"]="AnimationRule"
		["applications"]="CustomApplication"
		["assignmentRules"]="AssignmentRules"
		["audience"]="Audience"
		["aura"]="AuraDefinitionBundle"
		["brandingSets"]="BrandingSet"
		["businessProcesses"]="BusinessProcess"
		["cachePartitions"]="PlatformCachePartition"
		["callCenters"]="CallCenter"
		["classes"]="ApexClass"
		["compactLayouts"]="CompactLayout"
		["components"]="ApexComponent"
		["connectedApps"]="ConnectedApp"
		["contentassets"]="ContentAsset"
		["corsWhitelistOrigins"]="CorsWhitelistOrigin"
		["cspTrustedSites"]="CspTrustedSite"
		["customMetadata"]="CustomMetadata"
		["customPermissions"]="CustomPermission"
		["duplicateRules"]="DuplicateRule"
		["email"]="EmailTemplate"
		["experiences"]="ExperienceBundle"
		["fields"]="CustomField"
		["flexipages"]="FlexiPage"
		["flows"]="Flow"
		["globalValueSets"]="GlobalValueSet"
		["groups"]="Group"
		["label"]="CustomLabel"
		["labels"]="CustomLabels"
		["layouts"]="Layout"
		["LeadConvertSettings"]="LeadConvertSettings"
		["letterhead"]="Letterhead"
		["lightningExperienceThemes"]="LightningExperienceTheme"
		["listViews"]="ListView"
		["lwc"]="LightningComponentBundle"
		["managedTopics"]="ManagedTopics"
		["moderation"]="ModerationRule"
		["navigationMenus"]="NavigationMenu"
		["networkBranding"]="NetworkBranding"
		["networks"]="Network"
		["notificationtypes"]="CustomNotificationType"
		["objects"]="CustomObject"
		["objectTranslations"]="CustomObjectTranslation"
		["pages"]="ApexPage"
		["pathAssistants"]="PathAssistant"
		["permissionsetgroups"]="PermissionSetGroup"
		["permissionsets"]="PermissionSet"
		["queues"]="Queue"
		["quickActions"]="QuickAction"
		["profiles"]="Profile"
		["recordTypes"]="RecordType"
		["remoteSiteSettings"]="RemoteSiteSetting"
		["reportTypes"]="ReportType"
		["roles"]="Role"
		["sites"]="SiteDotCom"
		["sharingRules"]="SharingRules"
		["standardValueSets"]="StandardValueSet"
		["standardValueSetTranslations"]="StandardValueSetTranslation"
		["staticresources"]="StaticResource"
		["tabs"]="CustomTab"
		["territory2Models"]="Territory2Model"
		["territory2Types"]="Territory2Type"
		["translations"]="Translations"
		["triggers"]="ApexTrigger"
		["uiFormatSpecificationSets"]="UiFormatSpecificationSet"
		["userCriteria"]="UserCriteria"
		["validationRules"]="ValidationRule"
		["webLinks"]="WebLink"
	)
	local metadata_type="${folder_to_type_mapping[$folder]}"
	echo "${metadata_type:-}"
}

## find_folder_name_by_metadata_type
find_folder_name_by_metadata_type(){
	local metadata_type="$1"
	declare -A type_to_folder_mapping
	type_to_folder_mapping=(
		["AnimationRule"]="animationRules"
		["ApexClass"]="classes"
		["ApexComponent"]="components"
		["ApexPage"]="pages"
		["ApexTrigger"]="triggers"
		["AssignmentRules"]="assignmentRules"
		["Audience"]="audience"
		["AuraDefinitionBundle"]="aura"
		["BrandingSet"]="brandingSets"
		["BusinessProcess"]="businessProcesses"
		["CallCenter"]="callCenters"
		["CompactLayout"]="compactLayouts"
		["ContentAsset"]="contentassets"
		["CorsWhitelistOrigin"]="corsWhitelistOrigins"
		["CspTrustedSite"]="cspTrustedSites"
		["ConnectedApp"]="connectedApps"
		["CustomApplication"]="applications"
		["CustomField"]="fields"
		["CustomLabel"]="label"
		["CustomLabels"]="labels"
		["CustomMetadata"]="customMetadata"
		["CustomNotificationType"]="notificationtypes"
		["CustomObject"]="objects"
		["CustomObjectTranslation"]="objectTranslations"
		["CustomPermission"]="customPermissions"
		["CustomTab"]="tabs"
		["DuplicateRule"]="duplicateRules"
		["EmailTemplate"]="email"
		["ExperienceBundle"]="experiences"
		["FlexiPage"]="flexipages"
		["Flow"]="flows"
		["GlobalValueSet"]="globalValueSets"
		["Group"]="groups"
		["Layout"]="layouts"
		["LeadConvertSettings"]="LeadConvertSettings"
		["Letterhead"]="letterhead"
		["LightningComponentBundle"]="lwc"
		["LightningExperienceTheme"]="lightningExperienceThemes"
		["ListView"]="listViews"
		["ManagedTopics"]="managedTopics"
		["ModerationRule"]="moderation"
		["NavigationMenu"]="navigationMenus"
		["Network"]="networks"
		["NetworkBranding"]="networkBranding"
		["PathAssistant"]="pathAssistants"
		["PermissionSet"]="permissionsets"
		["PermissionSetGroup"]="permissionsetgroups"
		["PlatformCachePartition"]="cachePartitions"
		["Queue"]="queues"
		["QuickAction"]="quickActions"
		["Profile"]="profiles"
		["RecordType"]="recordTypes"
		["RemoteSiteSetting"]="remoteSiteSettings"
		["ReportType"]="reportTypes"
		["Role"]="roles"
		["SiteDotCom"]="sites"
		["SharingRules"]="sharingRules"
		["StandardValueSet"]="standardValueSets"
		["StandardValueSetTranslation"]="standardValueSetTranslations"
		["StaticResource"]="staticresources"
		["Territory2Model"]="territory2Models"
		["Territory2Type"]="territory2Types"
		["Translations"]="translations"
		["UiFormatSpecificationSet"]="uiFormatSpecificationSets"
		["UserCriteria"]="userCriteria"
		["ValidationRule"]="validationRules"
		["WebLink"]="webLinks"
	)
	folder="${type_to_folder_mapping[$metadata_type]}"
	echo "${folder:-}"
}

# Methods to manage files for deploy
## remove_unsupported_setting_for_lightning_experience
remove_unsupported_setting_for_lightning_experience(){
	if [ -d "${project_directory}settings/" ]; then
		echo -ne "- Removing ${RBlue}unsupported setting${NC} for lightning experience... "
		xml ed -L -N x="$xml_namespace" -d "//*/x:enableInAppLearning" "${project_directory}settings/LightningExperience.settings-meta.xml"
		echo "Done."
	fi
}

## remove_components_on_dashboards
remove_components_on_dashboards(){
	if [[ -d "${project_directory}dashboards/" ]]; then
		echo -ne "- Removing ${RBlue}components${NC} on dashboards... "
		while IFS= read -r dashboard_file; do
			xml ed -L -N x="$xml_namespace" -d "//*/x:dashboardGridComponents" "$dashboard_file"
		done < <(find "${project_directory}dashboards/" -type f -name "*.dashboard-meta.xml")
		echo "Done."
	fi
}

## remove_controlling_field_on_picklists
remove_controlling_field_on_picklists(){
	if [[ $(yq eval '.controlling_picklists_with_deploy_issue // "null"' "$config_file") != "null" ]]; then
		while IFS= read -r concatenation; do
			sobject=$(echo "$concatenation" | cut -d "." -f 1)
			picklist_api_name=$(echo "$concatenation" | cut -d "." -f 2)
			echo -ne "- Removing ${RBlue}picklist controlling values${NC} on ${sobject} picklist ${picklist_api_name}... "
			xml ed -L -N x="$xml_namespace" -d "//*/x:valueSettings" "${project_directory}objects/${sobject}/fields/${picklist_api_name}.field-meta.xml"
			xml ed -L -N x="$xml_namespace" -d "//*/x:controllingField" "${project_directory}objects/${sobject}/fields/${picklist_api_name}.field-meta.xml"
			echo "Done."
		done < <(yq eval '.controlling_picklists_with_deploy_issue[]' "$config_file")
	fi
}

## remove_consumer_key_on_each_connected_app
remove_consumer_key_on_each_connected_app(){
	if [ -d "${project_directory}connectedApps/" ]; then
		echo -ne "- Removing ${RBlue}consumer key${NC} on connected apps... "
		for filename in ${project_directory}connectedApps/*.connectedApp-meta.xml; do
			xml ed -L -N x="$xml_namespace" -d "//*/x:consumerKey" "$filename"
		done
		echo "Done."
	fi
}

## remove_domain_on_each_site
remove_domain_on_each_site(){
	if [ -d "${project_directory}sites/" ]; then
		echo -ne "- Removing ${RBlue}custom domain${NC} on sites... "
		for filename in ${project_directory}sites/*.site-meta.xml; do
			xml ed -L -N x="$xml_namespace" -d "//*/x:customWebAddresses" "$filename"
		done
		echo "Done."
	fi
}

## remove_users_from_queues
remove_users_from_queues(){
	if [ -d "${project_directory}queues/" ]; then
		echo -ne "- Removing ${RBlue}users${NC} from queues... "
		for filename in ${project_directory}queues/*.queue-meta.xml; do
			xml ed -L -N x="$xml_namespace" -d "//*/x:users" "$filename"
		done
		echo "Done."
	fi
}

## replace_sender_email_in_case_autoresponse_rule
replace_sender_email_in_case_autoresponse_rule(){
	local org_alias=$1
	echo -ne "- Removing ${RBlue}admin email${NC} from autoResponseRules... "
	if [ -z "$MY_EMAIL" ]; then
		if [ -n "$org_alias" ]; then
			local target_org="--target-org $org_alias"
		fi
		local current_org_details=$(sf org display $target_org --json | tr -d '\r')
		local current_user_email=$(echo "$current_org_details" | jq -r '.result.createdBy')
	else
		local current_user_email=$MY_EMAIL
	fi
	xml ed -L -N x="$xml_namespace" -u "//*/x:senderEmail" -v "$current_user_email" "${project_directory}autoResponseRules/Case.autoResponseRules-meta.xml"
	echo "Done."
}

## remove_missing_sobjects_from_viewallrecords_permission_sets
remove_missing_sobjects_from_viewallrecords_permission_sets(){
	if [[ $(yq eval '.viewallrecords_permissionsets // "null"' "$config_file") != "null" ]]; then
		echo -ne "- Removing ${RBlue}missing sObjects${NC} from permission set with 'ViewAllRecords' permission... "

		local missing_sobjects=("ActiveScratchOrg" "NamespaceRegistry" "ScratchOrgInfo")
		if [[ "$is_sandbox_org" = "true" ]]; then
			yaml_path='.sandbox'
		elif [[ "$is_scratch_org" = "true" ]]; then
			yaml_path='.scratch_org'
		fi
		if [[ -n "$yaml_path" && $(yq eval "$yaml_path.sobjects_to_remove // null" "$config_file") != "null" ]]; then
			while IFS= read -r sobject_to_remove; do
				missing_sobjects+=("$sobject_to_remove")
			done < <(yq eval "$yaml_path.sobjects_to_remove[]" "$config_file")
		fi

		while IFS= read -r viewallrecords_permissionset; do
			for missing_sobject in "${missing_sobjects[@]}"; do
				xml ed -L -N x="$xml_namespace" -d "//*/x:objectPermissions[starts-with(x:object, \"$missing_sobject\")]" "${project_directory}permissionsets/${viewallrecords_permissionset}.permissionset-meta.xml"
			done
		done < <(yq eval '.viewallrecords_permissionsets[]' "$config_file")

		echo "Done."
	fi
}

## add_missing_sobjects_in_viewallrecords_permission_sets
add_missing_sobjects_in_viewallrecords_permission_sets(){
	if [[ $(yq eval '.viewallrecords_permissionsets // "null"' "$config_file") != "null" ]]; then
		local yaml_path=""
		if [[ "$is_sandbox_org" = "true" ]]; then
			yaml_path=".sandbox.missing_sobjects"
		elif [[ "$is_scratch_org" = "true" ]]; then
			yaml_path=".scratch_org.missing_sobjects"
		fi
		if [[ -n "$yaml_path" && $(yq eval "$yaml_path // null" "$config_file") != "null" ]]; then
			echo -ne "- Adding ${RBlue}missing sObjects${NC} in permission set with 'ViewAllRecords' permission... "
			declare -A missing_sobject_map
			parse_yaml_to_assoc_array "$config_file" "$yaml_path" missing_sobject_map
			while IFS= read -r permissionset; do
				local filename="${project_directory}permissionsets/${permissionset}.permissionset-meta.xml"
				for sobject in "${!missing_sobject_map[@]}"; do
					add_sobject_to_permissionset "$filename" "$sobject" "${missing_sobject_map[$sobject]}"
				done
			done < <(yq eval '.viewallrecords_permissionsets[]' "$config_file")
			echo "Done."
		fi
	fi
}

## add_sobject_to_permissionset
add_sobject_to_permissionset(){
	local filename="$1"
	local sobject="$2"
	local missing_sobject="$3"

	xml ed -L -N x="$xml_namespace" -a "//*/x:objectPermissions[x:object=\"$sobject\"]" -t elem -n temporaryNode -v "" "$filename"
	xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n allowCreate -v "false" "$filename"
	xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n allowDelete -v "false" "$filename"
	xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n allowEdit -v "false" "$filename"
	xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n allowRead -v "true" "$filename"
	xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n modifyAllRecords -v "false" "$filename"
	xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n object -v "$missing_sobject" "$filename"
	xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n viewAllRecords -v "true" "$filename"
	xml ed -L -N x="$xml_namespace" -r "//*/x:temporaryNode" -v "objectPermissions" "$filename"
}

## remove_profile_search_layouts_in_sobjects
remove_profile_search_layouts_in_sobjects(){
	echo -ne "- Removing ${RBlue}profile search layouts${NC} from sobjects... "
	for object_file in $(find "${project_directory}objects/" -type f -name "*object-meta.xml"); do
		xml ed -L -N x="$xml_namespace" -d "//*/x:profileSearchLayouts" "$object_file"
	done
	echo "Done."
}

## remove_surveys_from_flexipages
remove_surveys_from_flexipages(){
	echo -ne "- Removing ${RBlue}surveys${NC} from flexipages... "
	for flexipage in $(find "${project_directory}flexipages/" -type f -name "*.flexipage-meta.xml"); do
		xml ed -L -N x="$xml_namespace" -d "//x:itemInstances/x:componentInstance[x:componentName = \"survey:survey\"]" "$flexipage"
		xml ed -L -N x="$xml_namespace" -d "//x:itemInstances/x:componentInstance[x:componentName = 'survey:survey']" -d "//x:itemInstances[not(node())]" "$flexipage"
	done
	echo "Done."
}

# Methods to help manage git branch
## merge_prod_release_into_master
merge_prod_release_into_master(){
	echo -ne "\nMerging ${RPurple}prod-release${NC} into ${RPurple}master${NC} branch... "
	yes y | git checkout master > /dev/null 2>&1
	yes y | git merge prod-release --no-edit > /dev/null 2>&1
	yes y | git push origin master > /dev/null 2>&1
	yes y | git checkout prod-release > /dev/null 2>&1
	echo "Done."
}

## delete_remote_branches_merged_into_master
delete_remote_branches_merged_into_master(){
	echo -e "\n${RRed}Deleting${NC} remote branches that have already been merged into the master branch..."
	yes y | git fetch --prune origin > /dev/null 2>&1
	local protected_branches=("master" "prod-release" "preprod")
	local merged_branches=$(git branch --remote --merged master | grep -v 'master')
	for branch in $merged_branches; do
		local branch_name="${branch#*/}"
		if ! [[ " ${protected_branches[*]} " =~ " $branch_name " ]]; then
			yes y | git push origin --delete "$branch_name" > /dev/null
		fi
	done
}

# Methods to help create a scratch org
## checking_salesforce_cli_configuration
checking_salesforce_cli_configuration(){
	echo -e "\nChecking ${RGreen}Salesforce CLI${NC} configuration..."
	local sf_config=$(sf config list --json 2>/dev/null)

	if [[ $? -ne 0 ]]; then
        local error_message=$(echo "$sf_config" | jq -r '.message // "Unknown error"')
        error_exit "Error: $error_message"
    fi

	local devhub_name=$(yq eval '.org_settings.devhub_name' "$config_file")
	local devhub=$(echo "$sf_config" | jq -e ".result[] | select(.name == \"target-dev-hub\" and .value == \"$devhub_name\")")
	if [ -z "$devhub" ]; then
		echo -ne "Setting ${RBlue}default dev hub${NC} to ${RPurple}${devhub_name}${NC}... "
		sf config set target-dev-hub=$devhub_name > /dev/null
		echo "Done."
	fi

	local templates=$(echo "$sf_config" | jq -e '.result[] | select(.name == "org-custom-metadata-templates")')
	if [ -z "$templates" ]; then
		echo -ne "Adding ${RBlue}custom templates${NC} for files created with Salesforce CLI... "
		sf config set org-custom-metadata-templates=https://github.com/BoboJD/SalesforceDX-Templates > /dev/null
		echo "Done."
	fi
}

## checking_node_modules
checking_node_modules(){
	if [ ! -d "node_modules" ]; then
		echo -e "Installing ${RBlue}node modules${NC}..."
		npm install --force --loglevel=error
	fi
}

## create_scratch_org
create_scratch_org(){
	local org_alias=$1
	local defaultusername_option=$2

	echo -e "\nVerifying if scratch org ${RPurple}$org_alias${NC} exists..."
	local existing_scratch_org=$(sf org list --json | jq ".result.scratchOrgs[] | select(.alias == \"$org_alias\")")
	if [ -n "$existing_scratch_org" ]; then
		echo -e "Scratch org ${RPurple}$org_alias${NC} has already been created."
	else
		echo -ne "Scratch org ${RPurple}$org_alias${NC} does not exist"
		local set_default=""
		if [ "$defaultusername_option" = "-s" ] || [ "$defaultusername_option" = "--set-default" ]; then
			echo -ne " as ${RGreen}default org${NC} for project"
			set_default="--set-default"
		fi
		echo ". Starting creation..."


		local scratch_org_creation_result=$(sf org create scratch -f config/project-scratch-def.json -y 30 -w 20 --json --alias $org_alias $set_default)

		local status=$(echo "$scratch_org_creation_result" | jq -r '.status')
		if [ "$status" -eq 0 ]; then
			echo -e "${RGreen}Scratch org has been created.${NC}"
		else
			local message=$(echo "$scratch_org_creation_result" | jq -r '.message')
			error_exit "Scratch org creation failed : $message"
		fi

		sleep 3 # Fix for unfound org

		echo -e "\nSetting ${RBlue}password${NC} for user..."
		sf org generate password --complexity 3 --length 16 --target-org $org_alias
	fi
}

## install_packages
install_packages(){
	local org_alias=$1
	if [[ $(yq eval '.org_settings.packages // "null"' "$config_file") != "null" ]]; then
		echo -e "\nVerifying installation of packages :"
		local devhub_name=$(yq eval '.org_settings.devhub_name' "$config_file")
		installed_packages_in_devhub=$(sf package installed list --target-org $devhub_name --json 2>/dev/null)
		installed_packages_in_org=$(sf package installed list --target-org $org_alias --json 2>/dev/null)
		while IFS= read -r package; do
			echo -ne "- ${RCyan}${package}${NC}... "
			devhub_data=$(echo "$installed_packages_in_devhub" | jq -r --arg name "$package" '.result[] | select(.SubscriberPackageName == $name)')
			devhub_version=$(echo "$devhub_data" | jq -r '.SubscriberPackageVersionNumber')
			package_id=$(echo "$devhub_data" | jq -r '.SubscriberPackageVersionId')

			if [[ -z "$devhub_version" || -z "$package_id" ]]; then
				echo -e "${Red}Package not found in DevHub${NC}"
				continue
			fi

			org_version=$(echo "$installed_packages_in_org" | jq -r --arg name "$package" '.result[] | select(.SubscriberPackageName == $name) | .SubscriberPackageVersionNumber')
			should_install=false
			if [[ -z "$org_version" ]]; then
				should_install=true
			else
				higher_version=$(printf "%s\n%s" "$devhub_version" "$org_version" | sort -V | tail -n1)
				if [[ "$org_version" != "$higher_version" ]]; then
					should_install=true
				else
					echo -e "${RYellow}Latest version already installed.${NC}"
				fi
			fi

			if $should_install; then
				echo -ne "Latest version not installed, starting installation..."
				package_installation_result=$(sf package install -p "$package_id" -w 60 -s AllUsers -r --target-org "$org_alias" --json 2>/dev/null)
				package_installation_status=$(echo "$package_installation_result" | jq -r '.status')
				if [ "$package_installation_status" -eq 0 ]; then
					echo -e "${Green}Successfully installed ${package}.${NC}"
				else
					package_installation_message=$(echo "$package_installation_result" | jq -r '.message')
					error_exit "Package installation failed: ${package_installation_message}"
				fi
			fi
		done < <(yq eval '.org_settings.packages[]' "$config_file")
	fi
}

## rename_api_name_of_standard_metadata
rename_api_name_of_standard_metadata(){
	local org_alias=$1
	if [[ $(yq eval '.standard_metadata_to_rename // "null"' "$config_file") != "null" ]]; then
		echo -ne "\nRenaming ${RBlue}standard metadata values${NC}... "
		while IFS= read -r concatenation; do
			metadata_type=$(echo "$concatenation" | cut -d ":" -f 1)
			old_value=$(echo "$concatenation" | cut -d ":" -f 2)
			new_value=$(echo "$concatenation" | cut -d ":" -f 3)
			sf metadata rename -t "$metadata_type" -o "$old_value" -n "$new_value" --targetusername $org_alias > /dev/null
		done < <(yq eval '.standard_metadata_to_rename[]' "$config_file")
		echo "Done."
	fi
}

## deploy
deploy(){
	local org_alias=$1
	local label=$2
	local source=$3
	echo -e "- Deploying ${RBlue}${label}${NC}..."
	local deploy_result=$(sf project deploy start --source-dir $source --ignore-conflicts --ignore-warnings --json --target-org $org_alias)
	local deploy_status=$(echo "$deploy_result" | jq -r '.status')
	if [ "$deploy_status" -eq 0 ]; then
		echo -e "${RGreen}Deployment successful.${NC}"
	else
		local deploy_url=$(echo "$deploy_result" | jq -r '.result.deployUrl')
		sf org open -p "$deploy_url" --target-org $org_alias
		error_exit "Deployment failed. Fix the errors then relaunch the script."
	fi
}

## remove_tlz_custom_permissions_on_profiles
remove_tlz_custom_permissions_on_profiles(){
	local org_alias=$1
	if [ -d "${project_directory}profiles/" ]; then
		local custom_permissions=(
			"tlz__BypassChatterNotification"
			"tlz__BypassProcessusContentDocumentLink"
			"tlz__BypassProcessusContentVersion"
			"tlz__BypassProcessusUser"
			"tlz__BypassValidationRules"
			"tlz__ErrorMessageVisible"
		)
		for profile in ${project_directory}profiles/*.profile-meta.xml; do
			local xml_content='<?xml version="1.0" encoding="UTF-8"?><Profile xmlns="http://soap.sforce.com/2006/04/metadata">'
			for custom_permission in "${custom_permissions[@]}"; do
				xml_content+="<customPermissions><enabled>false</enabled><name>$custom_permission</name></customPermissions>"
			done
			xml_content+="</Profile>"
			echo "$xml_content" > "$profile"
		done

		echo -n "Deleting tlz custom permissions assigned on profiles... "
		mv .forceignore .DISABLED.forceignore # so that profiles can be deployed
		sf project deploy start -m Profile --ignore-conflicts --ignore-warnings --json --target-org $org_alias > /dev/null
		mv .DISABLED.forceignore .forceignore
		git restore "${project_directory}profiles"
		echo "Done."
	fi
}

## activate_debug_mode_for_lightning_components
activate_debug_mode_for_lightning_components(){
	local org_alias=$1
	echo -ne "\nActivation of ${RBlue}Debug Mode${NC} for Lightning components... "
	sf texei debug lwc enable --target-org $org_alias > /dev/null
	echo "Done."
}

## import_data_from_production
import_data_from_production(){
	local org_alias=$1
	echo -e "\nStarting ${RBlue}import data${NC} from ${RPurple}production org${NC} to ${RPurple}scratch org${NC}..."
	local devhub_name=$(yq eval '.org_settings.devhub_name' "$config_file")
	sf sfdmu run --sourceusername $devhub_name --targetusername $org_alias --silent --nowarnings
	rm -r "target"
	rm "MissingParentRecordsReport.csv"
}