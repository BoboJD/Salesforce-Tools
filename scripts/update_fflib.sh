#!/bin/bash

main(){
    pull_fflib_changes
    update_fflib_directory
    add_system_to_assert_in_files "force-app/fflib/"
}

pull_fflib_changes(){
    echo "Pulling fflib changes..."
    apex_mocks_output=$(git subtree pull --prefix=fflib-apex-mocks git@github.com:apex-enterprise-patterns/fflib-apex-mocks.git master)
    apex_common_output=$(git subtree pull --prefix=fflib-apex-common git@github.com:apex-enterprise-patterns/fflib-apex-common.git master)
}

update_fflib_directory(){
    process_subtree_updates "Apex Mocks" "$apex_mocks_output" "fflib-apex-mocks/sfdx-source/apex-mocks" "force-app/fflib/"
    process_subtree_updates "Apex Common" "$apex_common_output" "fflib-apex-common/sfdx-source/apex-common" "force-app/fflib/"
}

process_subtree_updates(){
    local name="$1"
    local output="$2"
    local source_dir="$3"
    local target_dir="$4"

    if [[ -n "$output" ]]; then
        if [[ "$output" = *"Already up to date."* ]]; then
            echo "No changes in $name."
        else
            cp -r "$source_dir/main/"* "$target_dir"
            cp -r "$source_dir/test/"* "$target_dir"
            echo "$name has been updated."
        fi
    fi
}

add_system_to_assert_in_files(){
    local dir="$1"
    if [[ $apex_mocks_output != *"Already up to date."* || $apex_common_output != *"Already up to date."* ]]; then
        echo -n "Fixing deploy issue with 'Assert' in files... "
        find "$dir" -type f -exec sed -i '/System.Assert/!s/\bAssert\b/System.Assert/g' {} +
        echo "Done..."
    fi
}

main