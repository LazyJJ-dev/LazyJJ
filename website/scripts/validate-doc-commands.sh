#!/bin/bash
# Validate documentation commands against config files
#
# Compares commands mentioned in docs against actual commands defined in
# config/*.toml files. Reports any commands in docs that don't exist in config.
# Exit code 0 if all commands are valid, 1 if discrepancies found.

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CONFIG_DIR="$PROJECT_ROOT/config"
DOCS_DIR="$PROJECT_ROOT/website/src/content/docs"

# Extract aliases from all config TOML files
extract_config_commands() {
  grep -h '^\s*[a-z][a-z0-9_-]*\s*=' "$CONFIG_DIR"/lazyjj-*.toml \
    | sed 's/^\s*\([a-z][a-z0-9_-]*\)\s*=.*/\1/' \
    | sort -u
}

# Extract commands from docs
extract_doc_commands() {
  "$SCRIPT_DIR/extract-doc-commands.sh" "$DOCS_DIR"
}

# Known JJ built-in commands (not defined in our config)
BUILTINS=(
  "abandon"
  "add"          # Intentionally shown as non-existent in docs (educational)
  "bookmark"
  "branch"
  "commit"
  "config"
  "describe"
  "diff"
  "duplicate"
  "edit"
  "evolog"
  "file"
  "fix"
  "git"
  "import"
  "init"
  "interdiff"
  "log"
  "move"
  "new"
  "next"
  "op"
  "prev"
  "print"
  "rebase"
  "resolve"
  "restore"
  "run"
  "show"
  "sign"
  "simplify-parents"
  "sparse"
  "split"
  "squash"
  "status"
  "tag"
  "undo"
  "unsign"
  "util"
  "workspace"
)

is_builtin() {
  local cmd="$1"
  for builtin in "${BUILTINS[@]}"; do
    if [[ "$cmd" == "$builtin" ]]; then
      return 0
    fi
  done
  return 1
}

# Main validation
config_commands=$(extract_config_commands)
doc_commands=$(extract_doc_commands)

echo "Checking documentation commands against config..."
echo ""

found_issues=0

while IFS= read -r cmd; do
  # Skip if it's a built-in JJ command
  if is_builtin "$cmd"; then
    continue
  fi

  # Check if command exists in config
  if ! echo "$config_commands" | grep -qx "$cmd"; then
    echo "WARNING: '$cmd' used in docs but not defined in config"
    # Show where it's used
    grep -rn "jj $cmd" "$DOCS_DIR" --include="*.md" --include="*.mdx" | head -3
    echo ""
    found_issues=1
  fi
done <<< "$doc_commands"

if [[ $found_issues -eq 0 ]]; then
  echo "All documentation commands are valid."
  exit 0
else
  echo "Found commands in documentation that are not defined in config."
  exit 1
fi
