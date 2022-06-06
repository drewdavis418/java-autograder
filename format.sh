#! /usr/bin/env bash

# Runs black on macOS and Linux machines. Sorry, Windows users.

set -e

py_files=$(find -- src -type f -name "*.py")

echo "Running formatter..."
black $py_files