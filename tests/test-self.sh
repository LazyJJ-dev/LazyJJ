#!/bin/bash
# Test LazyJJ self-management commands

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

# Create a test repo
REPO_DIR=$(create_test_repo)
cd "$REPO_DIR"

# Test lazyjj cheat sheet
OUTPUT=$(jj lazyjj)

# Verify it contains expected sections
echo "$OUTPUT" | grep -q "LazyJJ" || { echo "Missing LazyJJ header"; exit 1; }
echo "$OUTPUT" | grep -q "CORE ALIASES" || { echo "Missing CORE ALIASES section"; exit 1; }
echo "$OUTPUT" | grep -q "STACK WORKFLOW" || { echo "Missing STACK WORKFLOW section"; exit 1; }
echo "$OUTPUT" | grep -q "GITHUB" || { echo "Missing GITHUB section"; exit 1; }
echo "$OUTPUT" | grep -q "lazyjj.dev" || { echo "Missing docs link"; exit 1; }

# Test lazyjj-update alias exists (just verify it's defined, don't actually run update)
jj config list | grep -q "aliases.lazyjj-update" || { echo "Missing lazyjj-update alias"; exit 1; }

echo "Self-management commands work correctly"

# Cleanup
rm -rf "$REPO_DIR"
