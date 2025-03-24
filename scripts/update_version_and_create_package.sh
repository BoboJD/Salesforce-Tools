#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"

echo -ne "\nChecking if ${RBlue}npm packages${NC} have update... "
ncu --upgrade --silent
if git diff --quiet package.json; then
	echo -e "${RYellow}All dependencies are up to date.${NC}"
else
	echo "Updates detected in package.json, starting installation..."
	npm install --force --loglevel=error
fi

npm run lint
if [ $? -ne 0 ]; then
  error_exit "Linting failed."
fi

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
if [ "$minor" -gt 99 ]; then
    minor=0
    major=$((major + 1))
fi
newVersion="$major.$minor.$newPatch.NEXT"

echo "New version: $newVersion"
echo "Replacing version number in sfdx-project.json..."
jq --arg newVersion "$newVersion" '.packageDirectories[0].versionNumber = $newVersion' sfdx-project.json > sfdx-project.json.tmp && mv sfdx-project.json.tmp sfdx-project.json

echo -e "${RGreen}Version number updated to $newVersion ${NC}"
echo "Creating new package version..."
package_name=$(jq -r '.packageDirectories[0].package' sfdx-project.json)
result=$(sf package version create --definition-file config/project-scratch-def.json --package "$package_name" --wait 30 --installation-key-bypass --code-coverage --json)
status=$(echo $result | jq -r '.status')

if [ "$status" = "0" ]; then
	packageStatus=$(echo $result | jq -r '.result.Status')
	if [ "$packageStatus" = "Success" ]; then
		subscriberPackageVersionId=$(echo $result | jq -r '.result.SubscriberPackageVersionId')
		echo -e "${RGreen}Package creation successful. Subscriber Package Version ID: $subscriberPackageVersionId ${NC}"
		echo "Promoting package version..."
		promote_result=$(sf package version promote --package $subscriberPackageVersionId --no-prompt --json)
		promote_status=$(echo $promote_result | jq -r '.status')
		if [ "$promote_status" = "0" ]; then
			jq --arg package_name "$package_name" '
				.packageAliases |= (
					{ ($package_name): .[$package_name] } +
					(to_entries
					| map(select(.key | startswith($package_name + "@")))
					| sort_by(.key | split("@")[1])
					| last
					| { (.key): .value }
					)
				)
			' "sfdx-project.json" > temp.json && mv temp.json "sfdx-project.json"
			echo -e "${RGreen}Promotion of package was successful.${NC}"
		else
			errors=$(echo $result | jq -r '.result.errors' | tr '\\n' '\n')
			error_exit "$errors"
		fi
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
