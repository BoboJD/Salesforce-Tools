#!/bin/bash
SECONDS=0
. "$SCRIPT_DIR/colors.sh"

# Common methods
## error_exit
error_exit() {
	echo -e "${RRed}Error: $1${NC}"
	display_duration_of_script
	exit 1
}

## is_array_with_elements
is_array_with_elements(){
	local var_name="$1"

	# Check if the variable is an array
	if declare -p "$var_name" 2>/dev/null | grep -q 'declare -a'; then
		# Get the length of the array
		local array_length
		array_length=$(eval "echo \${#$var_name[@]}")

		# Check if the array has elements
		if [ "$array_length" -gt 0 ]; then
			return 0 # Array exists and has elements
		else
			return 1 # Array exists but is empty
		fi
	else
		return 1 # Not an array
	fi
}

# Manage duration of scripts
## display_start_time
display_start_time(){
	local start_time=$(date +"%Hh%M")
	echo -e "Script started at ${RGreen}${start_time}${NC}\n"
	check_if_necessary_commands_are_available
}

check_if_necessary_commands_are_available(){
	command -v sf >/dev/null 2>&1 || error_exit "sf CLI is not installed."
	command -v jq >/dev/null 2>&1 || error_exit "jq is not installed."
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

# Methods to update cli if enabled in parameters.sh and used in scripts
## check_update_of_git
check_update_of_git(){
	echo -e "Checking if ${RBlue}git${NC} has update available..."
	git update-git-for-windows
}

## check_update_for_global_npm_packages
check_update_for_global_npm_packages(){
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
}

# Org information methods
## get_org_details
get_org_details() {
	if [ -z "$org_details" ]; then
		org_details=$(sf org display --json | tr -d '\r')
	fi
}

## check_production_org
check_production_org(){
	get_org_details
	local org_id=$(echo "$org_details" | jq -r '.result.id')
	[ "$org_id" = "$PRODUCTION_ORG_ID" ] && echo "true" || echo "false"
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

# Methods for deploy script
find_metadata_type_by_folder_name(){
	local folder="$1"

	declare -A folder_to_type_mapping

	folder_to_type_mapping=(
		["animationRules"]="AnimationRule"
		["applications"]="CustomApplication"
		["aura"]="AuraDefinitionBundle"
		["brandingSets"]="BrandingSet"
		["callCenters"]="CallCenter"
		["classes"]="ApexClass"
		["compactLayouts"]="CompactLayout"
		["components"]="ApexComponent"
		["contentassets"]="ContentAsset"
		["corsWhitelistOrigins"]="CorsWhitelistOrigin"
		["cspTrustedSites"]="CspTrustedSite"
		["customMetadata"]="CustomMetadata"
		["customPermissions"]="CustomPermission"
		["duplicateRules"]="DuplicateRule"
		["email"]="EmailTemplate"
		["fields"]="CustomField"
		["flexipages"]="FlexiPage"
		["flows"]="Flow"
		["globalValueSets"]="GlobalValueSet"
		["groups"]="Group"
		["label"]="CustomLabel"
		["layouts"]="Layout"
		["letterhead"]="Letterhead"
		["lightningExperienceThemes"]="LightningExperienceTheme"
		["listViews"]="ListView"
		["lwc"]="LightningComponentBundle"
		["notificationtypes"]="CustomNotificationType"
		["objects"]="CustomObject"
		["pages"]="ApexPage"
		["pathAssistants"]="PathAssistant"
		["permissionsetgroups"]="PermissionSetGroup"
		["permissionsets"]="PermissionSet"
		["queues"]="Queue"
		["quickActions"]="QuickAction"
		["remoteSiteSettings"]="RemoteSiteSetting"
		["roles"]="Role"
		["staticresources"]="StaticResource"
		["tabs"]="CustomTab"
		["triggers"]="ApexTrigger"
		["validationRules"]="ValidationRule"
		["webLinks"]="WebLink"
	)

	folder_type="${folder_to_type_mapping[$folder]}"
	echo "${folder_type:-}"
}

# Methods to manage files for deploy
## remove_unsupported_setting_for_lightning_experience
remove_unsupported_setting_for_lightning_experience(){
	echo -ne "- Removing ${RBlue}unsupported setting${NC} for lightning experience... "
	xml ed -L -N x="$xml_namespace" -d "//*/x:enableInAppLearning" "${project_directory}settings/LightningExperience.settings-meta.xml"
	echo "Done."
}

## remove_components_on_dashboards
remove_components_on_dashboards(){
	if [ "${#dashboards[@]}" -gt 0 ]; then
		echo -ne "- Removing ${RBlue}untracked reports${NC} on dashboards... "
		for dashboard in ${dashboards[@]}; do
			xml ed -L -N x="$xml_namespace" -d "//*/x:dashboardGridComponents" "${project_directory}dashboards/$dashboard.dashboard-meta.xml"
		done
		echo "Done."
	fi
}

## remove_controlling_field_on_picklists
remove_controlling_field_on_picklists(){
	if [ "${#controlling_picklists_with_deploy_issue[@]}" -gt 0 ]; then
		for concatenation in "${controlling_picklists_with_deploy_issue[@]}"; do
			sobject=$(echo "$concatenation" | cut -d "." -f 1)
			picklist_api_name=$(echo "$concatenation" | cut -d "." -f 2)
			echo -ne "- Removing ${RBlue}picklist controlling values${NC} on ${sobject} picklist ${picklist_api_name}... "
			xml ed -L -N x="$xml_namespace" -d "//*/x:valueSettings" "${project_directory}objects/${sobject}/fields/${picklist_api_name}.field-meta.xml"
			xml ed -L -N x="$xml_namespace" -d "//*/x:controllingField" "${project_directory}objects/${sobject}/fields/${picklist_api_name}.field-meta.xml"
			echo "Done."
		done
	fi
}

## remove_consumer_key_on_each_connected_app
remove_consumer_key_on_each_connected_app(){
	echo -ne "- Removing ${RBlue}consumer key${NC} on connected apps... "
	for filename in ${project_directory}connectedApps/*.connectedApp-meta.xml; do
		xml ed -L -N x="$xml_namespace" -d "//*/x:consumerKey" "$filename"
	done
	echo "Done."
}

## remove_domain_on_each_site
remove_domain_on_each_site(){
	echo -ne "- Removing ${RBlue}custom domain${NC} on sites... "
	for filename in ${project_directory}sites/*.site-meta.xml; do
		xml ed -L -N x="$xml_namespace" -d "//*/x:customWebAddresses" "$filename"
	done
	echo "Done."
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
	echo -ne "- Removing ${RBlue}missing sObjects${NC} from permission set with 'ViewAllRecords' permission... "

	local missing_sobjects=("ActiveScratchOrg" "NamespaceRegistry" "ScratchOrgInfo")

	if [ "$is_sandbox_org" = "true" ]; then
		missing_sobjects+=(
			"Address" "CalcMatrixColumnRange" "CalcProcStepRelationship" "CalculationMatrix" "CalculationMatrixColumn" "CalculationMatrixRow" "CalculationMatrixVersion"
			"CalculationProcedure" "CalculationProcedureStep" "CalculationProcedureVariable" "CalculationProcedureVersion" "Employee" "ExpressionSet" "ExpressionSetObjectAlias"
			"ExpressionSetVersion" "InternalOrganizationUnit" "SharingRecordCollection" "SvcCatalogReqRelatedItem" "SvcCatalogRequest"
		)
	fi

	for viewallrecords_permissionset in "${viewallrecords_permissionsets[@]}"; do
		for missing_sobject in "${missing_sobjects[@]}"; do
			xml ed -L -N x="$xml_namespace" -d "//*/x:objectPermissions[starts-with(x:object, \"$missing_sobject\")]" "${project_directory}permissionsets/${viewallrecords_permissionset}.permissionset-meta.xml"
		done
	done
	echo "Done."
}

## add_missing_sobjects_in_viewallrecords_permission_sets
add_missing_sobjects_in_viewallrecords_permission_sets(){
	echo -ne "- Adding ${RBlue}missing sObjects${NC} in permission set with 'ViewAllRecords' permission... "

	declare -A missing_sobjects

	if [ "$is_sandbox_org" = "true" ]; then
		missing_sobjects=(
			["AppAnalyticsQueryRequest"]="ArchiveJobSession"
			["Quote"]="RebatePayoutSnapshot"
			["UniteFonciere__c"]="UserDefinedLabel"
		)
		order_to_add_missing_sobjects=("AppAnalyticsQueryRequest" "Quote" "UniteFonciere__c")
	else
		missing_sobjects=(
			["AppAnalyticsQueryRequest"]="ArchiveJobSession"
			["Asset"]="AsyncRequestResponseEvent"
			["Case"]="CaseServiceProcess"
			["CaseUpdateStatus__e"]="ChangeRequest"
			["CustomerPortalNotification__e"]="DataKitDeploymentLog"
			["EnchereCapacite__c"]="EngagementAttendee"
			["EngagementAttendee"]="EngagementInteraction"
			["EngagementInteraction"]="EngagementTopic"
			["Image"]="Incident"
			["Individual"]="IntegrationProviderDef"
			["PrivacyConsent"]="Problem"
			["Product2"]="ProductRelatedServiceProcess"
			["Quote"]="RebatePayoutSnapshot"
			["RebatePayoutSnapshot"]="RecordActnSelItemExtrc"
			["RecordActnSelItemExtrc"]="RecordAlert"
			["SuiviFacturation__c"]="SvcCatalogItemDependency"
			["UniteFonciere__c"]="UserDefinedLabel"
			["WebCartDocument"]="WorkPlan"
			["WorkPlan"]="WorkPlanTemplate"
			["WorkPlanTemplate"]="WorkStepTemplate"
		)
		order_to_add_missing_sobjects=(
			"AppAnalyticsQueryRequest" "Asset" "Case" "CaseUpdateStatus__e" "CustomerPortalNotification__e" "EnchereCapacite__c" "EngagementAttendee" "EngagementInteraction" "Image" "Individual"
			"PrivacyConsent" "Product2" "Quote" "RebatePayoutSnapshot" "RecordActnSelItemExtrc" "SuiviFacturation__c" "UniteFonciere__c" "WebCartDocument" "WorkPlan"
			"WorkPlanTemplate"
		)
	fi

	for viewallrecords_permissionset in "${viewallrecords_permissionsets[@]}"; do
		local filename="${project_directory}permissionsets/${viewallrecords_permissionset}.permissionset-meta.xml"

		for sobject in "${order_to_add_missing_sobjects[@]}"; do
			missing_sobject="${missing_sobjects[$sobject]}"
			xml ed -L -N x="$xml_namespace" -a "//*/x:objectPermissions[x:object=\"$sobject\"]" -t elem -n temporaryNode -v "" "$filename"
			xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n allowCreate -v "false" "$filename"
			xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n allowDelete -v "false" "$filename"
			xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n allowEdit -v "false" "$filename"
			xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n allowRead -v "true" "$filename"
			xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n modifyAllRecords -v "false" "$filename"
			xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n object -v "$missing_sobject" "$filename"
			xml ed -L -N x="$xml_namespace" -s "//*/x:temporaryNode" -t elem -n viewAllRecords -v "true" "$filename"
			xml ed -L -N x="$xml_namespace" -r "//*/x:temporaryNode" -v "objectPermissions" "$filename"
		done
	done
	echo "Done."
}

# Methods to help manage git branch
## merge_prod_release_into_master
merge_prod_release_into_master(){
	echo -e "\nMerging ${RPurple}prod-release${NC} into ${RPurple}master${NC} branch..."
	yes y | git checkout master > /dev/null
	yes y | git merge prod-release --no-edit > /dev/null
	yes y | git push origin master > /dev/null
	yes y | git checkout prod-release > /dev/null
	echo -e "Branch ${RPurple}master${NC} is now up-to-date."
}

## delete_remote_branches_merged_into_master
delete_remote_branches_merged_into_master(){
	echo -e "\n${RRed}Deleting${NC} remote branches that have already been merged into the master branch... "
	yes y | git fetch --prune origin
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
	local sf_config=$(sf config list --json)

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

checking_node_modules(){
	if [ ! -d "node_modules" ]; then
		echo -e "Installing ${RBlue}node modules${NC}..."
		npm install --force
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
		local setdefaultusername=""
		if [ "$defaultusername_option" = "-s" ] || [ "$defaultusername_option" = "--setdefaultusername" ]; then
			echo -ne " as ${RGreen}default org${NC} for project"
			setdefaultusername="--set-default"
		fi
		echo ". Starting creation..."


		local scratch_org_creation_result=$(sf org create scratch -f config/project-scratch-def.json -y 30 -w 20 --json --alias $org_alias $setdefaultusername)

		local status=$(echo "$scratch_org_creation_result" | jq -r '.status')
		if [ "$status" -eq 0 ]; then
			echo -e "${RGreen}Scratch org has been created.${NC}"
		else
			error_exit "Scratch org creation failed. Relaunch the script."
		fi

		sleep 3 # Fix for unfound org

		echo -e "\nSetting ${RBlue}password${NC} for user..."
		sf org generate password --complexity 3 --length 16 --target-org $org_alias

		echo # Attempting to change org email deliverability to System
		sf deliverability access --level System --user $org_alias
	fi
}

## install_managed_packages
install_managed_packages(){
	local org_alias=$1
	if is_array_with_elements "appexchange_installation_order"; then
		echo -e "\nInstalling managed packages :"
		installed_packages=$(sf package installed list --target-org $org_alias --json)
		for appexchange_name in "${appexchange_installation_order[@]}"; do
			appexchange_id="${appexchange_id_by_name[$appexchange_name]}"
			check_package_installation $org_alias "$appexchange_id" "$appexchange_name"
		done
	fi
}

## check_package_installation
check_package_installation(){
	local org_alias=$1
	local package_id=$2
	local package_name=$3

	echo -ne "- Verifying installation of ${RCyan}${package_name}${NC} latest version... "
	local package_installed=$(echo "$installed_packages" | jq ".result[] | select(.SubscriberPackageVersionId == \"$package_id\")")

	if [ -n "$package_installed" ]; then
		echo -e "${RYellow}Latest version already installed.${NC}"
	else
		echo "Latest version not installed, starting installation..."
		local package_installation_result=$(sf package install -p "$package_id" -w 60 -s AllUsers -r --target-org $org_alias --json)
		local package_installation_status=$(echo "$package_installation_result" | jq -r '.status')
		if [ "$package_installation_status" -eq 0 ]; then
			echo -e "${RGreen}Successfully installed ${package_name} package.${NC}"
		else
			local reset_files=$(reset_changes_on_metadata_files)
			error_exit "Package installation failed. Relaunch the script."
		fi
	fi
}

## rename_api_name_of_standard_metadata
rename_api_name_of_standard_metadata(){
	local org_alias=$1
	if [ "${#standard_metadata_to_rename[@]}" -gt 0 ]; then
		echo -ne "\nRenaming ${RBlue}standard metadata values${NC}... "
		for concatenation in "${standard_metadata_to_rename[@]}"; do
			metadata_type=$(echo "$concatenation" | cut -d ":" -f 1)
			old_value=$(echo "$concatenation" | cut -d ":" -f 2)
			new_value=$(echo "$concatenation" | cut -d ":" -f 3)
			sf metadata rename -t "$metadata_type" -o "$old_value" -n "$new_value" --targetusername $org_alias > /dev/null
		done
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
		error_exit "Deployment failed. Fix the errors then relaunch the script."
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
	sf sfdmu run --sourceusername $devhub_name --targetusername $org_alias --silent --nowarnings
	rm -r "target"
	rm "MissingParentRecordsReport.csv"
}