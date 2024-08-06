#!/bin/sh
source ./scripts/utils.sh

main() {
	determine_current_branch
	define_branches_to_update
	fetch_and_pull_changes_of_branches
	prune_remote
	identify_and_delete_stale_local_branches
	echo -e "${RGreen}Workspace is now clean.${NC}"
}

determine_current_branch() {
	current_branch=$(git rev-parse --abbrev-ref HEAD)
	if [ $? -ne 0 ]; then
		error_exit "Failed to determine the current branch."
	fi
}

define_branches_to_update() {
	branches=("preprod")
	if [ "$current_branch" != "preprod" ]; then
		branches+=("prod-release" "master")
	fi
}

fetch_and_pull_changes_of_branches() {
	for branch in "${branches[@]}"; do
		echo -ne "Fetching and pulling changes for ${RCyan}${branch}${NC} branch... "
		if [ "$current_branch" = "$branch" ]; then
			yes y | git fetch origin "$current_branch" > /dev/null 2>&1 && yes y | git pull origin "$current_branch" > /dev/null 2>&1
		else
			yes y | git fetch -u origin "${branch}:${branch}" > /dev/null 2>&1
		fi
		if [ $? -ne 0 ]; then
			error_exit "Failed to update ${branch} branch."
		fi
		echo "Done."
	done
}

prune_remote() {
	echo -ne "Fetching ${RCyan}changes from remote and pruning${NC}... "
	yes y | git fetch --prune > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		error_exit "Failed to fetch and prune."
	fi
	echo "Done."
}

identify_and_delete_stale_local_branches() {
	echo -ne "Identifying and ${RRed}deleting stale local branches${NC}... "
	stale_branches=$(git branch -vv | awk '/: gone]/{print $1}')
	if [ -n "$stale_branches" ]; then
		echo "$stale_branches" | xargs -r git branch -D > /dev/null 2>&1
		if [ $? -ne 0 ]; then
			error_exit "Failed to delete stale branches."
		fi
	else
		echo -e "${RYellow}No stale branches to delete.${NC}"
	fi
}

main