#!/bin/sh
source ./scripts/parameters.sh
source ./scripts/utils.sh

display_start_time

echo -e "Starting ${RRed}deletion${NC} of files in default org..."

extraParametersForDeploy=""
is_production_org=$(check_production_org)
if [ "$is_production_org" = "true" ]; then
	extraParametersForDeploy="-l RunLocalTests"
fi
sf project deploy start -x manifest/emptyPackage.xml  --pre-destructive-changes manifest/destructiveChanges.xml -w 600 $extraParametersForDeploy

echo "Done deleting files in default org."

display_duration_of_script