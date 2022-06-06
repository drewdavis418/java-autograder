#! /usr/bin/env bash

# Runs black and pylint on macOS and Linux machines. Sorry, Windows users.

set -e

py_files=$(find -- src -type f -name "*.py")

echo "Running formatter..."
black --check $py_files
echo ""
echo "Running linter..."
pylint $py_files