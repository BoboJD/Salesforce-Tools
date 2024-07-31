#!/bin/bash

main(){
	pull_changes
	copy_changes_to_directory
	add_system_to_assert "force-app/fflib/"
}

pull_changes(){
	git subtree pull --prefix=fflib-apex-mocks git@github.com:apex-enterprise-patterns/fflib-apex-mocks.git master
	git subtree pull --prefix=fflib-apex-common git@github.com:apex-enterprise-patterns/fflib-apex-common.git master
}

copy_changes_to_directory(){
	cp -r fflib-apex-mocks/sfdx-source/apex-mocks/main/* force-app/fflib/
	cp -r fflib-apex-mocks/sfdx-source/apex-mocks/test/* force-app/fflib/
	cp -r fflib-apex-common/sfdx-source/apex-common/main/* force-app/fflib/
	cp -r fflib-apex-common/sfdx-source/apex-common/test/* force-app/fflib/
}

add_system_to_assert(){
	for item in "$1"/*; do
		if [[ -d "$item" ]]; then
			add_system_to_assert "$item"
		elif [[ -f "$item" ]]; then
			sed -i '/System.Assert/!s/\bAssert\b/System.Assert/g' "$item"
		fi
	done
}

main