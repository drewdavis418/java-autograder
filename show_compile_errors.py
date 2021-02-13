# Purdue CS Bridge Gradescope Autograder
# >> show_compile_errors.py
#
# Description:
#   This script runs if javac in run_autograder returns a
#   non-zero exit code when compiling a student submission.
#
# Last updated:
#   07/08/2020

import os
import json
import sys

path = '/autograder/results/results.json'

compiler_output = sys.stdin.read()

results = {}
results['tests'] = []
results['output'] = 'Unable to compile submission'
results['tests'].append({
    'output': compiler_output,
    'score': 0,
    'number': '',
    'visibility': 'visible',
    'max_score': 0,
    'name': 'Compiler Output',
})

# Write results.json
with open(path, 'w+') as fp:
    json.dump(results, fp, indent = 2)
