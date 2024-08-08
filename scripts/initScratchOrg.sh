#!/bin/sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
."$SCRIPT_DIR/utils.sh"
. ./scripts/parameters.sh

# Parameters
scratch_org_name=$1 # Mandatory to create the scratch org
option=$2 # Values : -s / --setdefaultusername

if [ -z "$scratch_org_name" ]; then
	error_exit "You need to provide a scratch org name."
fi

main(){
	display_start_time
	checking_salesforce_cli_configuration
	checking_node_modules
	create_scratch_org $scratch_org_name $option
	deploy_project
	assign_permissionsets_to_current_user
	import_data
	echo -e "\n${RGreen}Scratch org is ready !${NC}"
	display_duration_of_script
}

deploy_project(){
	echo -e "\nStarting deployment of project :"
	deploy "Apex Mocks" "fflib-apex-mocks/sfdx-source"
	deploy "Apex Common" "fflib-apex-common/sfdx-source"
	deploy "Project metadata files" "force-app"
}

deploy(){
	local label=$1
	local source=$2
	echo -e "- Deploying ${RBlue}${label}${NC}..."
	local deploy_result=$(sf project deploy start --source-dir $source --ignore-conflicts --ignore-warnings --json --target-org $scratch_org_name)
	local deploy_status=$(echo "$deploy_result" | jq -r '.status')
	if [ "$deploy_status" -eq 0 ]; then
		echo -e "${RGreen}Deployment successful.${NC}"
	else
		error_exit "Deployment failed. Fix the errors then relaunch the script."
	fi
}

assign_permissionsets_to_current_user(){
	echo -ne "\nAssigning ${RBlue}permissionsets${NC} to current user... "
	sf org assign permset -n ToolsAdmin > /dev/null
	echo "Done."
}

import_data(){
	echo -ne "\Importing ${RBlue}data${NC} to scratch org... "
	sf data import tree --files data/tlz__EncryptionKey__c.json > /dev/null
	echo "Done."
}

main