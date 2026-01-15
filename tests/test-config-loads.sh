#!/bin/bash
# Test that all config files load without errors

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

# Create a test repo
REPO_DIR=$(create_test_repo)
cd "$REPO_DIR"

# Verify JJ can load the config
jj config list > /dev/null

# Check that key settings are present
CONFIG=$(jj config list)

# Check for aliases
echo "$CONFIG" | grep -q "aliases.st" || { echo "Missing aliases.st"; exit 1; }
echo "$CONFIG" | grep -q "aliases.d" || { echo "Missing aliases.d"; exit 1; }
echo "$CONFIG" | grep -q "aliases.l" || { echo "Missing aliases.l"; exit 1; }

# Check for revset aliases
echo "$CONFIG" | grep -q "revset-aliases.trunk" || { echo "Missing revset-aliases.trunk"; exit 1; }
echo "$CONFIG" | grep -q "revset-aliases.stack" || { echo "Missing revset-aliases.stack"; exit 1; }

echo "All config files loaded successfully"

# Cleanup
rm -rf "$REPO_DIR"
