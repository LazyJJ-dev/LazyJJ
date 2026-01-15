#!/bin/bash
# Test that core aliases work

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

# Create a test repo
REPO_DIR=$(create_test_repo)
cd "$REPO_DIR"

# Test status alias
jj st > /dev/null

# Test diff alias
jj d > /dev/null

# Test log alias
jj l > /dev/null

# Test full log alias
jj ll > /dev/null

# Test history alias
jj hist > /dev/null

# Test diff summary
jj diffs > /dev/null

# Test diff list
jj diffls > /dev/null

echo "All core aliases work"

# Cleanup
rm -rf "$REPO_DIR"
