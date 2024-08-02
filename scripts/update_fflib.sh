#!/bin/bash

main(){
	pull_changes
	copy_changes_to_directory
	# add_system_to_assert "force-app/fflib/"
	echo "fflib has been updated."
}

pull_changes(){
	echo "Pulling fflib changes..."
	apex_mocks_output=$(git subtree pull --prefix=fflib-apex-mocks git@github.com:apex-enterprise-patterns/fflib-apex-mocks.git master)
	apex_common_output=$(git subtree pull --prefix=fflib-apex-common git@github.com:apex-enterprise-patterns/fflib-apex-common.git master)
}

copy_changes_to_directory(){
	echo "$apex_mocks_output"
	if [[ $apex_mocks_output = *"Already up to date."* ]]; then
		echo "No changes on apex mocks."
	# else
		# cp -r fflib-apex-mocks/sfdx-source/apex-mocks/main/* force-app/fflib/
		# cp -r fflib-apex-mocks/sfdx-source/apex-mocks/test/* force-app/fflib/
	fi
	if [[ $apex_common_output = *"Already up to date."* ]]; then
		echo "No changes on apex common."
	# else
		# cp -r fflib-apex-common/sfdx-source/apex-common/main/* force-app/fflib/
		# cp -r fflib-apex-common/sfdx-source/apex-common/test/* force-app/fflib/
	fi
}

add_system_to_assert(){
	if [[ $apex_mocks_output != *"Already up to date."* || $apex_common_output != *"Already up to date."* ]]; then
		echo "Fixing deploy issue with 'Assert' in files..."
		for item in "$1"/*; do
			if [[ -d "$item" ]]; then
				add_system_to_assert "$item"
			elif [[ -f "$item" ]]; then
				sed -i '/System.Assert/!s/\bAssert\b/System.Assert/g' "$item"
			fi
		done
	fi
}

main