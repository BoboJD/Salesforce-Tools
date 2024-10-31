#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"

# Parameters
scratch_org_name=$1
option=$2 # Values : -s / --set-default

if [ -z "$scratch_org_name" ]; then
	echo "No scratch org name provided. Please enter a scratch org name:"
	read scratch_org_name
	if [ -z "$scratch_org_name" ]; then
		error_exit "You need to provide a scratch org name."
	fi
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
	deploy $scratch_org_name "Project metadata files" "force-app"
}

assign_permissionsets_to_current_user(){
	echo -ne "\nAssigning ${RBlue}permissionsets${NC} to current user... "
	sf org assign permset -n ToolsAdmin > /dev/null
	echo "Done."
}

import_data(){
	echo -ne "\nImporting ${RBlue}data${NC} to scratch org... "
	sf data import tree --files data/tlz__EncryptionKey__c.json > /dev/null
	echo "Done."
}

main