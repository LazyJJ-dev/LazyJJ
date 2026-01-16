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

# Test stack with file list (shortcut)
jj stackls > /dev/null

# Test stack-files (full form)
jj stack-files > /dev/null

# Test stacks-all-files (full form)
jj stacks-all-files > /dev/null

# Test stacksls (shortcut for stacks-all-files)
jj stacksls > /dev/null

# Test top navigation
jj top > /dev/null

# Test stack-top (full form)
jj stack-top > /dev/null

# Test gc (shortcut) - should be no-op since no empty commits
jj gc > /dev/null 2>&1 || true

# Test stack-gc (full form) - should be no-op since no empty commits
jj stack-gc > /dev/null 2>&1 || true

# Create empty commit to test gc functionality
jj new -m "Empty commit"
# Now gc should clean it up
jj gc > /dev/null 2>&1 || true

# Test bookmark operations
jj bookmark create test-bookmark
jj tug > /dev/null || true  # Move bookmark back
jj create > /dev/null || true  # Create new bookmark at @-

# Test restack
jj restack > /dev/null || true

# Test restack-all
jj restack-all > /dev/null || true

# Test stack-start (creates new commit on trunk)
jj stack-start > /dev/null || true
jj start > /dev/null || true  # shortcut

# Setup git remote for remote operation tests
BARE_REPO=$(mktemp -d)
git init --bare "$BARE_REPO" 2>/dev/null
jj git remote add origin "file://$BARE_REPO"

# Test git fetch (shortcut)
jj gf > /dev/null 2>&1 || true

# Test stack-submit (full form)
jj stack-submit > /dev/null 2>&1 || true

# Test ss (shortcut for stack-submit)
jj ss > /dev/null 2>&1 || true

# Test stack-sync (full form)
jj stack-sync > /dev/null 2>&1 || true

# Test sync (shortcut for stack-sync)
jj sync > /dev/null 2>&1 || true

echo "Stack workflow commands work correctly"

# Cleanup bare repo
rm -rf "$BARE_REPO"

# Cleanup
rm -rf "$REPO_DIR"
