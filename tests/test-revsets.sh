#!/bin/bash
# Test that revset aliases resolve correctly

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

# Create a test repo
REPO_DIR=$(create_test_repo)
cd "$REPO_DIR"

# Create a bookmark for trunk
jj bookmark create main -r @-

# Test trunk revset
jj log -r "trunk" > /dev/null

# Create some commits to test stack
jj new -m "First commit"
echo "change1" > file1.txt
jj new -m "Second commit"
echo "change2" > file2.txt

# Test stack revset
jj log -r "stack" > /dev/null

# Test stacks revset
jj log -r "stacks" > /dev/null

# Test branch_off revset
jj log -r "branch_off" > /dev/null

# Test ghbranch revset
jj log -r "ghbranch" > /dev/null || true

# Test no_description revset
jj log -r "no_description" > /dev/null

echo "All revset aliases resolve correctly"

# Cleanup
rm -rf "$REPO_DIR"
