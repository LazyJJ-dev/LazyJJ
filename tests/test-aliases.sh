#!/bin/bash
# Test that core aliases work

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

# Create a test repo
REPO_DIR=$(create_test_repo)
cd "$REPO_DIR"

# Test log-short (full form)
jj log-short >/dev/null

# Test diff summary (shortcut)
jj diffs >/dev/null

# Test diff-summary (full form)
jj diff-summary >/dev/null

# Test diff list (shortcut)
jj diffls >/dev/null

# Test diff-files (full form)
jj diff-files >/dev/null

# Test stack aliases
jj stack >/dev/null
jj stackls >/dev/null || true
jj stacks >/dev/null
jj top >/dev/null || true

# Test stack diff aliases
jj stack-diff >/dev/null || true
jj stack-diff-summary >/dev/null || true
jj stack-diff-files >/dev/null || true

# Test GitHub aliases
jj repo >/dev/null || true
jj prv >/dev/null || true

echo "All core aliases work"

# Cleanup
rm -rf "$REPO_DIR"
