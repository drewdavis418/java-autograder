#! /usr/bin/env bash

# Purdue CS Bridge Gradescope Autograder
# >> run_autograder
#
# Description:
#   This script runs when a student
#   uploads their code to Gradescope.
#
# Last updated:
#   04/16/2022

# Declare paths
autograder="/autograder/source/autograder.jar"
submission="/autograder/submission"
submission_output="/autograder/compiled_submission"
results_file="/autograder/results/results.json"

# Set script to exit if error occurs
set -e

# Open submission
#cd /autograder/submission

# Find submitted files
java_files=$( find -- $submission/* -type f -name "*.java" )
kotlin_files=$( find -- $submission/* -type f -name "*.kt" )

if [[ -z $java_files && -z $kotlin_files ]]; then
	# TODO: Show error in results.json
	exit 1
fi

# Compile student submission
# If the compile fails for any reason, invoke the show_compile_errors.py script and exit
# Note: $java_files is being split by word, which is why it is not in quotes. We
#       stopped using an array of files due to the compiler having issues with flags
#       and not displaying a useful error message. (disabled SC2086 below)
# shellcheck disable=SC2086
[[ -n $java_files ]] && javac -encoding UTF-8 -d $submission_output $java_files 2> /autograder/javac.log
[[ -n $kotlin_files ]] && kotlinc -d $submission_output $kotlin_files 2> /autograder/kotlinc.log

# Consolidate compiler errors
[[ -f /autograder/javac.log ]] && cat /autograder/javac.log >> /autograder/compiler.log
[[ -f /autograder/kotlinc.log ]] && cat /autograder/kotlinc.log >> /autograder/compiler.log

# Show compiler errors
[[ -s /autograder/compiler.log ]] && { python3 /autograder/source/show_compile_errors.py; exit 1; }

# Run the autograder
# Note: $autograder comes before $submission_output to guard
#       against class injection. The autograder JAR should not
#       contain compiled starter code (otherwise the starter code
#       will take precedence over the submission).
java -cp $autograder:$submission_output TestRunner > $results_file
