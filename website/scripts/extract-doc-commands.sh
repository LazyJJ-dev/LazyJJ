#!/bin/bash
# Extract JJ commands from documentation
#
# Parses all markdown files in the docs directory and extracts `jj <command>`
# patterns from code blocks and inline code only. Outputs unique commands
# sorted alphabetically.

set -euo pipefail

DOCS_DIR="${1:-$(dirname "$0")/../src/content/docs}"

# Use awk to extract jj commands only from:
# 1. Fenced code blocks (between ``` markers)
# 2. Inline backtick code (`jj command`)
find "$DOCS_DIR" -name "*.md" -o -name "*.mdx" | xargs awk '
  # Track if we are inside a fenced code block
  /^```/ { in_code_block = !in_code_block; next }

  # Inside code block: extract jj commands
  in_code_block && /jj [a-z][a-z0-9_-]+/ {
    # Extract all jj commands from the line
    line = $0
    while (match(line, /jj [a-z][a-z0-9_-]+/)) {
      cmd = substr(line, RSTART + 3, RLENGTH - 3)
      print cmd
      line = substr(line, RSTART + RLENGTH)
    }
  }

  # Outside code block: only extract from inline backticks
  !in_code_block && /`jj [a-z][a-z0-9_-]+/ {
    line = $0
    while (match(line, /`jj [a-z][a-z0-9_-]+/)) {
      # Extract command (skip the backtick and "jj ")
      cmd = substr(line, RSTART + 4, RLENGTH - 4)
      print cmd
      line = substr(line, RSTART + RLENGTH)
    }
  }
' | sort -u
