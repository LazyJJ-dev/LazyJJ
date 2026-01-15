#!/bin/bash
# Test helpers for LazyJJ tests

# Create a test repository with JJ initialized
create_test_repo() {
    local dir="${1:-$(mktemp -d)}"
    mkdir -p "$dir"
    cd "$dir"
    git init -q
    git config user.email "test@lazyjj.dev"
    git config user.name "LazyJJ Test"
    echo "initial" > README.md
    git add README.md
    git commit -q -m "Initial commit"
    jj git init --colocate 2>/dev/null
    echo "$dir"
}
