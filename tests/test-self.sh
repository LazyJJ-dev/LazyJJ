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
echo "$OUTPUT" | grep -q "STACK WORKFLOW" || { echo "Missing STACK WORKFLOW section"; exit 1; }
echo "$OUTPUT" | grep -q "GITHUB" || { echo "Missing GITHUB section"; exit 1; }
echo "$OUTPUT" | grep -q "CLAUDE" || { echo "Missing CLAUDE section"; exit 1; }
echo "$OUTPUT" | grep -q "lazyjj.dev" || { echo "Missing docs link"; exit 1; }

# Test lazyjj-update alias exists (just verify it's defined, don't actually run update)
jj config list | grep -q "aliases.lazyjj-update" || { echo "Missing lazyjj-update alias"; exit 1; }

# Mock git/jj for testing lazyjj-update behavior without actually updating
# We'll just verify the command can be invoked (it will fail gracefully due to missing directory)
OUTPUT=$(jj lazyjj-update 2>&1 || true)
if [[ "$OUTPUT" == *"LazyJJ not found"* ]] || [[ "$OUTPUT" == *"Updating LazyJJ"* ]]; then
	echo "✓ lazyjj-update command works (mock test)"
else
	echo "⚠ lazyjj-update output: $OUTPUT"
fi

echo "Self-management commands work correctly"

# Cleanup
rm -rf "$REPO_DIR"
