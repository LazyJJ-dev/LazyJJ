#!/bin/bash
# LazyJJ Test Runner
# Run all tests in isolation

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LAZYJJ_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Run in container if requested
if [ "$1" = "--container" ]; then
	echo "Building test container..."
	docker build -t lazyjj-tests -f "$SCRIPT_DIR/Dockerfile" "$LAZYJJ_DIR"
	echo "Running tests in container..."
	docker run --rm lazyjj-tests
	exit $?
fi

# Set up isolated environment
export HOME=$(mktemp -d)
export JJ_CONFIG="$LAZYJJ_DIR/config:$SCRIPT_DIR/config"
export XDG_CONFIG_HOME="$HOME/.config"

# Create minimal JJ config for user settings
mkdir -p "$HOME/.config/jj"
cat >"$HOME/.config/jj/config.toml" <<'EOF'
[user]
name = "LazyJJ Test"
email = "test@lazyjj.dev"
EOF

# Set up git user
git config --global user.email "test@lazyjj.dev"
git config --global user.name "LazyJJ Test"

echo "Running LazyJJ tests..."
echo "JJ_CONFIG: $JJ_CONFIG"
echo ""

PASSED=0
FAILED=0

# Find and run all test scripts
for test_file in "$SCRIPT_DIR"/test-*.sh; do
	if [ -f "$test_file" ]; then
		test_name=$(basename "$test_file" .sh)
		echo -n "Running $test_name... "

		# Create temp dir for this test
		TEST_DIR=$(mktemp -d)
		cd "$TEST_DIR"

		if bash "$test_file" >"$TEST_DIR/output.log" 2>&1; then
			echo -e "${GREEN}PASSED${NC}"
			PASSED=$((PASSED + 1))
		else
			echo -e "${RED}FAILED${NC}"
			echo "--- Output ---"
			cat "$TEST_DIR/output.log"
			echo "--- End ---"
			FAILED=$((FAILED + 1))
		fi

		# Cleanup
		rm -rf "$TEST_DIR"
	fi
done

echo ""
echo -e "Results: ${GREEN}$PASSED passed${NC}, ${RED}$FAILED failed${NC}"

if [ $FAILED -gt 0 ]; then
	exit 1
fi
