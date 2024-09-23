#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"

# Parameters (not mandatory)
# -f / --fast : release branch into preprod, prod-release & master branch
# by default, this is the parameter for the target branch where you want to release your feature
target_branch=$1

main(){
	control_current_branch_state
	if [[ $current_branch = "hotfix" || $current_branch = "admin" || $target_branch = "-f" || $target_branch = "--fast" ]]; then
		merge_current_branch_in_every_branch
	elif [ $current_branch = "prod-release" ]; then
		merge_prod_release_into_master
		delete_remote_branches_merged_into_master
		echo -e "${RGreen}Release done.${NC}"
	elif [[ $current_branch == "release/"* ]]; then
		display_pull_request_uri
	else
		create_release_branch_for_feature_or_project
	fi
}

control_current_branch_state(){
	current_branch=$(git symbolic-ref --short HEAD)

	# Block execution of script on master branch
	if [ $current_branch = "master" ]; then
		error_exit "Cannot run release script on '$current_branch' branch."
	fi

	# Check if there are any unstaged changes
    if ! git diff-index --quiet HEAD --; then
        error_exit "There are unstaged changes on the current branch '$current_branch'. Please commit or stash them before proceeding."
    fi

	# Check if the current branch exists on the remote
    if ! git ls-remote --exit-code --heads origin $current_branch > /dev/null; then
        error_exit "Current branch '$current_branch' has not been pushed to the remote. Please push it before proceeding."
    fi

    # Check if the current branch has unpushed commits
    if [ "$(git rev-parse $current_branch)" != "$(git rev-parse origin/$current_branch)" ]; then
        error_exit "Current branch '$current_branch' has unpushed commits. Please push them before proceeding."
    fi
}

merge_current_branch_in_every_branch(){
	echo -e "\nReleasing ${RPurple}${current_branch}${NC} into ${RBlue}preprod${NC}, ${RBlue}prod-release${NC} & ${RBlue}master${NC} branches :"
	branches=("preprod" "prod-release" "master")
	for branch in "${branches[@]}"; do
		echo -ne "\n - Switching on ${RBlue}${branch}${NC}... "
		yes y | git fetch origin "${branch}:${branch}" > /dev/null 2>&1
		yes y | git checkout "${branch}" > /dev/null 2>&1
		echo -n "Merging changes... "
		if yes y | git merge --no-ff "$current_branch" --no-edit > /dev/null 2>&1; then
			echo -n "Updating remote... "
			yes y | git push origin "${branch}" > /dev/null 2>&1
			echo "Done."
		else
			error_exit "Merge conflict detected on branch ${branch}. Resolve conflicts then push manually. You can restart the script from branch '${current_branch}' after."
		fi
	done
	echo -ne "\n - Deleting ${RPurple}${current_branch}${NC} branch... "
	yes y | git push origin --delete $current_branch > /dev/null 2>&1
	yes y | git branch -D $current_branch > /dev/null 2>&1
	echo "Done."
	echo -e "\n${RGreen}Release done.${NC}"
}

create_release_branch_for_feature_or_project(){
	retrieve_feature_or_project_name
	ask_for_target_branch_if_not_provided
	check_if_target_branch_is_preprod_or_prod_release
	create_release_branch_from_target_branch
	exit_script_if_nothing_to_merge
	merge_feature_or_project_into_release_branch
}

retrieve_feature_or_project_name(){
	prefix="feature/"
	if [[ $current_branch == $prefix* ]]; then
		name=${current_branch#$prefix}
	else
		prefix="project/"
		if [[ $current_branch == $prefix* ]]; then
			name=${current_branch#$prefix}
		else
			error_exit "Current branch '$current_branch' doesn't have the expected prefix 'feature/' or 'project/'."
		fi
	fi
}

ask_for_target_branch_if_not_provided(){
	if [ -z "$target_branch" ]; then
		PS3="Select target branch : "
		options=("preprod" "prod-release")

		select environment in "${options[@]}"; do
			case $environment in
				"preprod")
					target_branch="preprod"
					break
					;;
				"prod-release")
					target_branch="prod-release"
					break
					;;
				*)
					echo "Invalid option, please choose 1 or 2."
					;;
			esac
		done
	fi
}

check_if_target_branch_is_preprod_or_prod_release(){
	if [[ "$target_branch" != "preprod" && "$target_branch" != "prod-release" ]]; then
		error_exit "Invalid target branch '$target_branch'. Allowed values are 'preprod' or 'prod-release'."
	fi
}

create_release_branch_from_target_branch(){
	echo -ne "Fetching and pulling ${RPurple}${target_branch}${NC} branch before releasing... "
	yes y | git fetch origin $target_branch:$target_branch > /dev/null 2>&1
	echo "Done."
	release_branch="release/${name}-${target_branch}"
	if git show-ref --quiet refs/heads/$release_branch; then
		echo -e "Branch ${RBlue}${release_branch}${NC} already exists locally."
   		remote_branch="origin/$release_branch"
		if git ls-remote --exit-code --heads origin $release_branch > /dev/null; then
			echo -ne "Remote branch ${RBlue}${remote_branch}${NC} exists. Checking out... "
			yes y | git checkout $release_branch  > /dev/null 2>&1
			echo "Done."
		else
			echo -ne "Remote branch ${RBlue}${remote_branch}${NC} does not exist. Recreating local branch... "
			yes y | git branch -D $release_branch > /dev/null 2>&1
			yes y | git checkout -b $release_branch $target_branch > /dev/null 2>&1
			echo "Done."
		fi
	else
		echo -ne "Creating new branch ${RBlue}${release_branch}${NC} from ${RPurple}${target_branch}${NC}... "
		yes y | git checkout -b $release_branch $target_branch > /dev/null 2>&1
		echo "Done."
	fi
}

exit_script_if_nothing_to_merge(){
	if yes y | git merge-base --is-ancestor $current_branch $release_branch; then
		yes y | git checkout $current_branch
		yes y | git branch -D $release_branch
		error_exit "No changes to merge into '${target_branch}'."
	fi
}

merge_feature_or_project_into_release_branch(){
	echo -ne "Merging changes on ${RBlue}${release_branch}${NC} branch... "
	if yes y | git merge --no-ff $current_branch --no-edit; then
		yes y | git push --set-upstream origin $release_branch > /dev/null 2>&1
		echo "Done."

		echo -e "\nRelease of ${RGreen}${name}${NC} into ${RGreen}${target_branch}${NC} is ready !"
		display_pull_request_uri
		echo

		yes y | git checkout $current_branch > /dev/null 2>&1
	else
		error_exit "Merge conflict detected. Resolve conflicts and push manually. Then relaunch the script from '$release_branch' branch if you want the pull request uri."
	fi
}

display_pull_request_uri(){
	release_branch=$(git rev-parse --abbrev-ref HEAD)
	target_branch=$( [[ $release_branch == *"prod-release"* ]] && echo "prod-release" || echo "preprod" )
	if [[ $release_branch =~ release/(.*)-$target_branch ]]; then
		feature="${BASH_REMATCH[1]}"
	fi
	echo -e "\nTo open a pull request, go to :"
	local github_repository_url=$(yq eval '.project.github_repository_url' "$config_file")
	echo -e "\n${RCyan}    ${github_repository_url}/compare/${target_branch}...${release_branch}?title=New%20release%20:%20%27${feature}%27%20into%20%27${target_branch}%27${NC}"
}

main