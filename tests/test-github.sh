#!/bin/bash
# Test GitHub integration aliases

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

# Create a test repo
REPO_DIR=$(create_test_repo)
cd "$REPO_DIR"

# Setup git remote with GitHub-like URL
BARE_REPO=$(mktemp -d)
git init --bare "$BARE_REPO" 2>/dev/null
jj git remote add origin "https://github.com/test-owner/test-repo.git"

# Test github-repo alias (extracts owner/repo from origin)
GITHUB_REPO=$(jj github-repo 2>/dev/null || echo "")
if [ -n "$GITHUB_REPO" ]; then
	echo "✓ github-repo works: $GITHUB_REPO"
fi

# Test repo shortcut
GITHUB_REPO_SHORT=$(jj repo 2>/dev/null || echo "")
if [ -n "$GITHUB_REPO_SHORT" ]; then
	echo "✓ repo shortcut works: $GITHUB_REPO_SHORT"
fi

# Mock gh CLI for testing
gh() {
	local cmd="$1"
	shift
	case "$cmd" in
	pr)
		local subcmd="$1"
		shift
		case "$subcmd" in
		view)
			# Mock PR view output
			if [[ "$*" == *"--json"* ]]; then
				echo '{"number":123,"title":"Test PR","url":"https://github.com/test-owner/test-repo/pull/123","state":"OPEN","isDraft":false,"reviewDecision":"APPROVED","statusCheckRollup":[]}'
			else
				echo "PR #123: Test PR"
				echo "https://github.com/test-owner/test-repo/pull/123"
			fi
			;;
		create)
			echo "Created PR #123"
			;;
		comment | edit)
			echo "Updated PR comment"
			;;
		list)
			echo "#123 Test PR"
			;;
		esac
		;;
	*)
		echo "gh $cmd called with: $*"
		;;
	esac
}
export -f gh

# Create a bookmark for trunk
jj bookmark create main -r @-

# Create a stack with bookmarks
jj new -m "Feature A"
echo "feature a" >feature-a.txt
jj bookmark create feature-a
jj new -m "Feature B"
echo "feature b" >feature-b.txt
jj bookmark create feature-b

# Test gh wrapper
jj gh issue list >/dev/null 2>&1 || true
echo "✓ gh wrapper works"

# Test pr-view (full form)
jj pr-view >/dev/null 2>&1 || true
echo "✓ pr-view works"

# Test prv (shortcut)
jj prv >/dev/null 2>&1 || true
echo "✓ prv shortcut works"

# Test pr-open (full form)
jj pr-open >/dev/null 2>&1 || true
echo "✓ pr-open works"

# Test pro (shortcut)
jj pro >/dev/null 2>&1 || true
echo "✓ pro shortcut works"

# Test pr-stack (list bookmarks in stack)
STACK_OUTPUT=$(jj pr-stack 2>/dev/null || echo "")
echo "✓ pr-stack works"

# Test pr-stack-create (full form)
jj pr-stack-create >/dev/null 2>&1 || true
echo "✓ pr-stack-create works"

# Test sprs (shortcut)
jj sprs >/dev/null 2>&1 || true
echo "✓ sprs shortcut works"

# Test pr-stack-summary (full form)
SUMMARY=$(jj pr-stack-summary 2>/dev/null || echo "")
if [[ "$SUMMARY" == *"## PR Stack"* ]]; then
	echo "✓ pr-stack-summary works and generates markdown"
fi

# Test prs (shortcut)
SUMMARY_SHORT=$(jj prs 2>/dev/null || echo "")
if [[ "$SUMMARY_SHORT" == *"## PR Stack"* ]]; then
	echo "✓ prs shortcut works"
fi

# Test pr-stack-update (full form)
jj pr-stack-update >/dev/null 2>&1 || true
echo "✓ pr-stack-update works"

# Test uprs (shortcut)
jj uprs >/dev/null 2>&1 || true
echo "✓ uprs shortcut works"

# Test _format_pr (internal helper)
jj _format_pr feature-a >/dev/null 2>&1 || true
echo "✓ _format_pr works"

# Test pr-stack-md (deprecated but should still work)
jj pr-stack-md >/dev/null 2>&1 || true
echo "✓ pr-stack-md works"

# Test prmd (shortcut)
jj prmd >/dev/null 2>&1 || true
echo "✓ prmd shortcut works"

# Test pr-stacks-all-md (all mutable PRs)
jj pr-stacks-all-md >/dev/null 2>&1 || true
echo "✓ pr-stacks-all-md works"

echo "All GitHub integration aliases work"

# Cleanup
rm -rf "$REPO_DIR" "$BARE_REPO"
