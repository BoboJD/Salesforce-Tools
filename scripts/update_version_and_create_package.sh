#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"

echo "Calculating new version number..."
currentVersion=$(jq -r '.packageDirectories[0].versionNumber' sfdx-project.json)
major=$(echo $currentVersion | cut -d '.' -f 1)
minor=$(echo $currentVersion | cut -d '.' -f 2)
patch=$(echo $currentVersion | cut -d '.' -f 3 | sed 's/NEXT//')
newPatch=$(($patch + 1))
if [ "$newPatch" -gt 9 ]; then
    newPatch=0
    minor=$(($minor + 1))
fi
newVersion="$major.$minor.$newPatch.NEXT"

echo "New version: $newVersion"
echo "Replacing version number in sfdx-project.json..."
jq --arg newVersion "$newVersion" '.packageDirectories[0].versionNumber = $newVersion' sfdx-project.json > sfdx-project.json.tmp && mv sfdx-project.json.tmp sfdx-project.json

echo -e "${RGreen}Version number updated to $newVersion ${NC}"
echo "Creating new Salesforce package version..."
result=$(sf package version create --definition-file config/project-scratch-def.json --package "Salesforce Tools" --wait 30 --installation-key-bypass --code-coverage --json)
status=$(echo $result | jq -r '.status')

if [ "$status" = "0" ]; then
    packageStatus=$(echo $result | jq -r '.result.Status')
    if [ "$packageStatus" = "Success" ]; then
        subscriberPackageVersionId=$(echo $result | jq -r '.result.SubscriberPackageVersionId')
        echo -e "${RGreen}Package creation successful. Subscriber Package Version ID: $subscriberPackageVersionId ${NC}"
        echo "Promoting package version..."
        sf package version promote --package $subscriberPackageVersionId --no-prompt
    else
		git restore sfdx-project.json
        error_exit "Package creation failed with status: $packageStatus"
    fi
else
    git restore sfdx-project.json
	errorCode=$(echo $result | jq -r '.code')
    errorMessage=$(echo $result | jq -r '.message')
    if [ "$errorCode" = "MultipleErrorsError" ]; then
        echo "Multiple errors occurred:"
        errors=$(echo $result | jq -r '.message' | tr '\\n' '\n')
        error_exit "$errors"
    else
        error_exit "Error occurred: $errorMessage"
    fi
fi
