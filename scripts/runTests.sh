#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
. "$SCRIPT_DIR/utils.sh"

# Parameters (not mandatory)
# you can provide the id of a test to display test results, ex: 707G500000RSZs7
# you can provide the name of the test class, ex: DateUtilsTest
# you can add '--output-file' to create a file that contains the output of each command
option=$1

# Search for coverage of a class
class_name=$2

main(){
	display_start_time
	if [[ "$option" == 707* ]]; then
		test_run_id="${option:0:15}"
	else
		run_test_and_store_id
	fi
	trap ctrl_c SIGINT
	if [ "$option" = "--output-file" ]; then
		output_file="test_output.txt" > $output_file
	fi
	extract_test_result
	display_org_wide_coverage
	display_classes_with_coverage_issue
	display_classes_without_coverage
	display_failed_tests
	if [ -n "$class_name" ]; then
		display_class_coverage
	fi
	remove_test_folder
	display_duration_of_script
}

run_test_and_store_id(){
	echo -n "Starting to run "
	if [[ -z "$option" || "$option" = "--output-file" ]]; then
		echo "all apex tests..."
		test_option="--test-level RunLocalTests"
	else
		echo -e "tests of ${RPurple}${option}${NC} class..."
		test_option="--class-names ${option}"
	fi
	test_run=$(sf apex run test $test_option --result-format json --code-coverage --json)

	test_run_id=$(echo "$test_run" | jq -r '.result.testRunId')
	echo -e "Test run id : ${BYellow}${test_run_id}${NC}\n"
}

ctrl_c(){
	echo -ne "\n${RYellow}Aborting tests... ${NC}"
	apex_file=$(mktemp)
cat <<EOF > "$apex_file"
List<ApexTestQueueItem> queues = [SELECT Id FROM ApexTestQueueItem WHERE ParentJobId = '${test_run_id}'];
for(ApexTestQueueItem queue : queues){
	queue.Status = 'ABORTED';
}
update queues;
EOF
	sf apex run --file "$apex_file" > /dev/null 2>&1
	echo -e "${RYellow}Done${NC}"
	exit 1
}

extract_test_result(){
	echo -e "Extracting result of test ${RYellow}${test_run_id}${NC}..."
	test_folder="testresults/"
	sf apex get test --test-run-id $test_run_id --code-coverage --result-format json --output-dir $test_folder > /dev/null 2>&1
	test_file="${test_folder}test-result-${test_run_id}.json"
}

display_org_wide_coverage(){
	org_wide_coverage=$(jq -r '.summary.orgWideCoverage' "$test_file")
	echo -e "\nOrganization-wide Coverage : $org_wide_coverage"
}

display_classes_with_coverage_issue() {
	ignore_selectors=$(yq eval '.test_settings.ignore_selectors // "false"' "$config_file")
	min_coverage=$(yq eval '.test_settings.min_coverage // "75"' "$config_file")

	selector_exclusion=""
	if [[ "$ignore_selectors" == "true" ]]; then
		selector_exclusion='or endswith("Selector")'
	fi

	classes_with_coverage_issue=$(jq -r --argjson min_coverage "$min_coverage" --arg selector_exclusion "$selector_exclusion" '
		.coverage.coverage[]
		| select(
			.coveredPercent < $min_coverage
			and .coveredPercent != 0
			and (
				.name
				| (
					startswith("fflib_")
					or startswith("ConnectApiService")
					or startswith("RollupHelper")
					or startswith("ForgotPasswordController")
					or startswith("MicrobatchSelfRegController")
					or startswith("MyProfilePageController")
					or startswith("SiteRegisterController")
					or startswith("tlz_OrgWideEmailAddressesSelector")
					'"$selector_exclusion"'
				)
				| not
			)
		)
		| "• \(.name): \(.coveredPercent)%"
	' "$test_file")

	if [ -n "$classes_with_coverage_issue" ]; then
		echo -e "\nClass with coverage less than $min_coverage%:"
		echo "$classes_with_coverage_issue" | sort
		if [ "$option" = "--output-file" ]; then
			echo -e "\nClass with coverage less than $min_coverage%:" >> $output_file
			echo "$classes_with_coverage_issue" | sort >> $output_file
		fi
	fi
}

display_classes_without_coverage(){
	classes_without_coverage=$(jq -r --arg selector_exclusion "$selector_exclusion" '
		.coverage.coverage[]
		| select(
			.coveredPercent == 0
			and (
				.name
				| (
					startswith("fflib_")
					or startswith("CustomException")
					'"$selector_exclusion"'
				)
				| not
			)
		)
		| "• \(.name)"
	' "$test_file")

	if [ -n "$classes_without_coverage" ]; then
		echo -e "\nClass without coverage:"
		echo "$classes_without_coverage" | sort
		if [ "$option" = "--output-file" ]; then
			echo -e "\nClass without coverage:" >> $output_file
			echo "$classes_without_coverage" | sort >> $output_file
		fi
	fi
}

display_failed_tests(){
	echo -ne "\nChecking if tests have failed... "
	failed_tests=$(jq -r --arg BRed "$BRed" --arg IRed "$IRed" --arg NC "$NC" '.tests[] | select((.Outcome | startswith("Fail"))) | "• \($BRed)\(.ApexClass.Name) \(.MethodName)()\($NC)\n\($IRed)\(.Message)\($NC)\n"' "$test_file")
	if [ -n "$failed_tests" ]; then
		failing_number=$(jq -r '.summary.failing' "$test_file")
		echo -e "\n${RRed}${failing_number} tests have failed :${NC}"
		echo -e "$failed_tests"
		if [ "$option" = "--output-file" ]; then
			echo -e "\n${RRed}${failing_number} tests have failed :${NC}" >> $output_file
			echo -e "$failed_tests" >> $output_file
		fi
	else
		echo "Done."
	fi
}

display_class_coverage(){
	class_coverage=$(jq -r --arg class_name "$class_name" '
		.coverage.coverage[]
		| select(.name | test("\($class_name)$"))
		| "\(.coveredPercent)%"
	' "$test_file")

	if [ -n "$class_coverage" ]; then
		echo -e "\nCoverage of ${RBlue}${class_name}${NC} class : ${class_coverage}"
	else
		echo -e "\nNo coverage data found for class: ${RBlue}${class_name}${NC}"
	fi
}

remove_test_folder(){
	rm -rf $test_folder
}

main