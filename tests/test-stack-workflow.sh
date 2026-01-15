#!/bin/bash
# Test stack workflow commands

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

# Create a test repo
REPO_DIR=$(create_test_repo)
cd "$REPO_DIR"

# Create a bookmark for trunk
jj bookmark create main -r @-

# Create a stack of commits
jj new -m "First in stack"
echo "change1" > file1.txt
jj new -m "Second in stack"
echo "change2" > file2.txt
jj new -m "Third in stack"
echo "change3" > file3.txt

# Test stack view
jj stack > /dev/null

# Test stacks view
jj stacks > /dev/null

# Test stack with file list
jj stackls > /dev/null

# Test top navigation
jj top > /dev/null

# Test bottom navigation
jj bottom > /dev/null

# Navigate back to top for further tests
jj top > /dev/null

# Test gc (should be no-op since no empty commits)
jj gc > /dev/null 2>&1 || true

echo "Stack workflow commands work correctly"

# Cleanup
rm -rf "$REPO_DIR"
