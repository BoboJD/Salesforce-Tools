#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"

main(){
	display_start_time
	block_script_if_is_not_running_in_production
	initialize_iteration_start_date
	loop_through_each_10_minutes_and_archive_logs
	echo -e "\n${RGreen}The logs have been archived.${NC}"
	display_duration_of_script
}

block_script_if_is_not_running_in_production(){
	echo -ne "Checking current org type... "
	is_production_org=$(check_production_org)
	if [ "$is_production_org" = "false" ]; then
		error_exit "Script can only be launched on production org."
	fi
	echo "Done."
}

initialize_iteration_start_date(){
	echo -ne "Retrieving first iteration date... "
	local first_created_log=$(sf data query --query "SELECT CreatedDate FROM Log__c ORDER BY CreatedDate ASC LIMIT 1" --json)
	if [ $? -ne 0 ]; then
		error_exit "Failed to retrieve the first log creation date."
	fi
	local created_date=$(echo $first_created_log | jq -r '.result.records[0].CreatedDate')
	# Set minutes and seconds to 00:00
	local created_date_hour=$(echo $created_date | sed 's/:[0-5][0-9]:[0-5][0-9]Z/:00:00Z/')
	local created_timestamp=$(date -d "$created_date_hour" +%s)
	iteration_timestamp=$created_timestamp
	echo "Done."
}

loop_through_each_10_minutes_and_archive_logs(){
	# Calculate the first day of the current week (Monday)
	local current_week_day_of_week=$(date +%u)
	local current_week_first_day_timestamp=$(date -d "today - $((current_week_day_of_week - 1)) days" +%s)

	# Loop through each 10 minutes and archive logs
	while [ $iteration_timestamp -lt $current_week_first_day_timestamp ]; do
		archive_logs $iteration_timestamp
	done
}

archive_logs(){
	local start_timestamp=$1
	local end_timestamp=$((start_timestamp + 600))
	local formatted_start_date=$(date -d "@$start_timestamp" +%Y-%m-%dT%H:%M:00%z)
	local formatted_end_date=$(date -d "@$end_timestamp" +%Y-%m-%dT%H:%M:00%z)
	local soql_start_date="${formatted_start_date/Z/}"
	local soql_end_date="${formatted_end_date/Z/}"

	# Replace colons with dashes for the filename
	local file_safe_start_date=$(echo $formatted_start_date | tr ':' '-')

	# Extract the day for the folder name
	local log_day=$(date -d "@$start_timestamp" +%Y-%m-%d)

	# Create the directory if it doesn't exist
	local archive_logs_folder=$(yq eval '.project.archive_logs_folder' "$config_file")
	local directory_path="${archive_logs_folder}\\${log_day}"
	mkdir -p "$directory_path"

	echo -e "\nArchiving logs from ${RYellow}${soql_start_date}${NC} to ${RYellow}${soql_end_date}${NC} into folder..."
	local soql_query="SELECT Id, RecordTypeId, CreatedDate, CreatedById, FileName__c, Message__c, Parameters__c, StackTrace__c, Type__c, Method__c, StatusCode__c, FormFactor__c FROM Log__c WHERE CreatedDate >= ${soql_start_date} AND CreatedDate < ${soql_end_date} ORDER BY CreatedDate ASC"
	local csv_file="${directory_path}\\logs_${file_safe_start_date}.csv"
	sf data query --query "$soql_query" --bulk --wait 600 -r csv > "$csv_file"
	if [ $? -ne 0 ]; then
		error_exit "Failed to archive logs."
	fi

	if [[ $(stat -c%s "$csv_file") -lt 5 ]]; then
		echo -e "${RYellow}No logs found.${NC}"
		rm "$csv_file"
		initialize_iteration_start_date # Rerun to get new created_timestamp
	else
		echo -e "\nRetrieving Id of logs to delete from Salesforce..."
		sf data query --query "SELECT Id FROM Log__c WHERE CreatedDate >= ${soql_start_date} AND CreatedDate < ${soql_end_date} ORDER BY CreatedDate ASC" --bulk --wait 600 -r csv > "logs_to_delete.csv"
		if [ $? -ne 0 ]; then
			error_exit "Failed to retrieve logs to delete."
		fi
		unix2dos logs_to_delete.csv

		echo -e "\nStarting deletion..."
		local devhub_name=$(yq eval '.org_settings.devhub_name' "$config_file")
		sf data delete bulk --sobject Log__c --file logs_to_delete.csv --wait 600 --hard-delete -o $devhub_name
		if [ $? -ne 0 ]; then
			error_exit "Failed to delete logs."
		fi
		rm logs_to_delete.csv
		iteration_timestamp=$((iteration_timestamp + 600)) # Move to the next 10 minutes only if logs were found and processed
	fi
}

main