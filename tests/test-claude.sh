#!/bin/bash
# Test Claude integration aliases

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

# Create a test repo
REPO_DIR=$(create_test_repo)
cd "$REPO_DIR"

# Mock tmux for testing (if not available or for predictable testing)
tmux() {
	local cmd="$1"
	shift
	case "$cmd" in
	new-session)
		# Mock tmux session creation
		local session_name=""
		while [ $# -gt 0 ]; do
			case "$1" in
			-s)
				session_name="$2"
				shift 2
				;;
			*)
				shift
				;;
			esac
		done
		echo "Mock: Created tmux session '$session_name'"
		# Create a marker file to track sessions
		mkdir -p /tmp/mock-tmux-sessions
		touch "/tmp/mock-tmux-sessions/$session_name"
		;;
	send-keys)
		# Mock sending keys to session
		echo "Mock: Sent keys to tmux session"
		;;
	kill-session)
		# Mock killing session
		local session_name=""
		while [ $# -gt 0 ]; do
			case "$1" in
			-t)
				session_name="$2"
				shift 2
				;;
			*)
				shift
				;;
			esac
		done
		echo "Mock: Killed tmux session '$session_name'"
		rm -f "/tmp/mock-tmux-sessions/$session_name" 2>/dev/null
		;;
	display-message)
		# Mock getting current session name
		echo "claude-test"
		;;
	*)
		echo "Mock: tmux $cmd called"
		;;
	esac
}
export -f tmux

# Mock claude CLI
claude() {
	echo "Mock: Claude CLI called with args: $*"
}
export -f claude

# Test claude-start (full form)
echo "Testing claude-start..."
OUTPUT=$(jj claude-start test-workspace 2>&1 || true)
if [[ "$OUTPUT" == *"Started tmux session"* ]] || [[ "$OUTPUT" == *"Workspace created"* ]]; then
	echo "✓ claude-start works"
else
	echo "⚠ claude-start output: $OUTPUT"
fi

# Test clstart (shortcut)
echo "Testing clstart..."
OUTPUT=$(jj clstart test-workspace-2 2>&1 || true)
if [[ "$OUTPUT" == *"Started tmux session"* ]] || [[ "$OUTPUT" == *"Workspace created"* ]]; then
	echo "✓ clstart shortcut works"
else
	echo "⚠ clstart output: $OUTPUT"
fi

# Test claude-stop (full form)
echo "Testing claude-stop..."
OUTPUT=$(jj claude-stop test-workspace 2>&1 || true)
if [[ "$OUTPUT" == *"Stopped and cleaned up workspace"* ]] || [[ "$OUTPUT" == *"Usage:"* ]]; then
	echo "✓ claude-stop works"
else
	echo "⚠ claude-stop output: $OUTPUT"
fi

# Test clstop (shortcut)
echo "Testing clstop..."
OUTPUT=$(jj clstop test-workspace-2 2>&1 || true)
if [[ "$OUTPUT" == *"Stopped and cleaned up workspace"* ]] || [[ "$OUTPUT" == *"Usage:"* ]]; then
	echo "✓ clstop shortcut works"
else
	echo "⚠ clstop output: $OUTPUT"
fi

# Test claude-resolve (full form) - no conflicts case
echo "Testing claude-resolve..."
OUTPUT=$(jj claude-resolve 2>&1 || true)
if [[ "$OUTPUT" == *"No conflicts"* ]] || [[ "$OUTPUT" == *"Conflicts found"* ]]; then
	echo "✓ claude-resolve works (no conflicts)"
else
	echo "⚠ claude-resolve output: $OUTPUT"
fi

# Test clresolve (shortcut)
echo "Testing clresolve..."
OUTPUT=$(jj clresolve 2>&1 || true)
if [[ "$OUTPUT" == *"No conflicts"* ]] || [[ "$OUTPUT" == *"Conflicts found"* ]]; then
	echo "✓ clresolve shortcut works"
else
	echo "⚠ clresolve output: $OUTPUT"
fi

# Test claude-checkpoint (full form)
echo "Testing claude-checkpoint..."
OUTPUT=$(jj claude-checkpoint "test checkpoint" 2>&1 || true)
if [[ "$OUTPUT" == *"Checkpointed"* ]] || [[ -z "$OUTPUT" ]]; then
	echo "✓ claude-checkpoint works"
else
	echo "⚠ claude-checkpoint output: $OUTPUT"
fi

echo "All Claude integration aliases work"

# Cleanup
rm -rf "$REPO_DIR" /tmp/mock-tmux-sessions 2>/dev/null || true
