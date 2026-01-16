#!/bin/bash
# Test helpers for LazyJJ tests

# Create a test repository with JJ initialized
create_test_repo() {
	local dir="${1:-$(mktemp -d)}"
	mkdir -p "$dir"
	cd "$dir"
	jj git init --no-colocate 2>/dev/null
	echo "initial" >README.md
	jj commit -m "Initial commit"
	echo "$dir"
}
