#!/bin/bash

main(){
    pull_fflib_changes
    add_system_to_assert_in_files "force-app/fflib-apex-common/sfdx-source"
}

pull_fflib_changes(){
    echo "Pulling fflib changes..."
    apex_mocks_output=$(git subtree pull --prefix=force-app/fflib-apex-mocks git@github.com:apex-enterprise-patterns/fflib-apex-mocks.git master)
    apex_common_output=$(git subtree pull --prefix=force-app/fflib-apex-common git@github.com:apex-enterprise-patterns/fflib-apex-common.git master)
}

add_system_to_assert_in_files(){
    local dir="$1"
    if [[ $apex_common_output != *"Already up to date."* ]]; then
        echo -n "Fixing deploy issue with 'Assert' in files... "
        find "$dir" -type f -exec sed -i '/System.Assert/!s/\bAssert\b/System.Assert/g' {} +
        echo "Done..."
    fi
}

main