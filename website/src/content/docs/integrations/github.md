---
title: GitHub Integration
description: Create and manage stacked PRs with GitHub CLI
---

LazyJJ integrates with GitHub CLI (`gh`) to create and manage stacked pull requests.

## Prerequisites

Install GitHub CLI and authenticate:

```bash
# Install gh (see https://cli.github.com/)
brew install gh  # macOS
# or your package manager

# Authenticate
gh auth login
```

## PR Commands

| Command | Shortcut | Purpose |
|---------|----------|---------|
| `pr-view` | `prv` | View current PR |
| `pr-open` | `pro` | Open current PR in browser |
| `pr-stack` | `prstack` | List bookmarks in stack |
| `pr-stack-create` | `sprs` | Create/update stacked PRs |
| `pr-stack-summary` | `prs` | Generate PR stack summary |
| `pr-stack-update` | `uprs` | Update PR comments with stack info |
| `pr-stack-slack` | `slackstack` | Slack-formatted PR stack |

## Basic Workflow

```bash
# View the PR for your current branch
jj pr-view

# Open it in the browser
jj pr-open
```

## Stacked PRs

LazyJJ makes stacked PRs easy. First, create bookmarks for each commit:

```bash
# Create your stack
jj stack-start
jj describe -m "Add database schema"
jj bookmark-create db-schema
jj new

jj describe -m "Add user model"
jj bookmark-create user-model
jj new

jj describe -m "Add user API"
jj bookmark-create user-api
```

Then create/update all PRs at once:

```bash
# Create stacked PRs for all bookmarks
jj pr-stack-create
```

This will:
1. Push each bookmark to the remote
2. Create a PR for each bookmark
3. Set the base branch correctly for stacking

## PR Stack Summary

Generate a summary of your PR stack:

```bash
# Markdown format
jj pr-stack-summary

# Output:
# ## PR Stack
#
# - [user-api](https://github.com/...): Add user API
# - [user-model](https://github.com/...): Add user model
# - [db-schema](https://github.com/...): Add database schema
```

Update PR descriptions with the stack summary:

```bash
jj pr-stack-update
```

## Slack Integration

Share your PR stack status in Slack:

```bash
jj pr-stack-slack

# Output:
# *PR Stack*
#
# :white_check_mark: <url|user-api>: Add user API
# :large_yellow_circle: <url|user-model>: Add user model
# :white_check_mark: <url|db-schema>: Add database schema
```

## Understanding Bookmarks and Branches

One of the most common sources of confusion:

- **JJ calls them**: Bookmarks
- **GitHub calls them**: Branches
- **They're the same thing**

### Why Bookmarks Don't Auto-Follow

Unlike Git branches, JJ bookmarks stay where you set them:

```bash
jj bookmark-create my-feature  # Bookmark at current commit
jj new -m "More work"          # Create new commit
jj log
# my-feature is still at the old commit!

# Update manually:
jj bookmark set my-feature -r @
```

Research shows 11 out of 20 JJ resources mention this as a common confusion. See [Common Mistakes](/guides/common-mistakes/#mistake-2-expecting-bookmarks-to-auto-follow) for details.

### The `ghbranch` Revset

LazyJJ provides a revset to find the current bookmark for GitHub:

```bash
# See which bookmark will be used
jj log -r ghbranch
```

## Utility Commands

| Command | Shortcut | Purpose |
|---------|----------|---------|
| `github-repo` | `repo` | Get GitHub repo from origin |
| `github-cli` | `gh` | Run any gh command in repo context |

```bash
# Get the repo name
jj github-repo  # -> owner/repo

# Run any gh command
jj github-cli pr list
jj github-cli issue create
```

## Tips

### Finding the Right Bookmark

LazyJJ uses `ghbranch` to find the bookmark for the current position:

```bash
# See which bookmark will be used
jj log -r ghbranch
```

### Rebasing After Merge

When a PR in your stack is merged:

```bash
# Sync with trunk (rebases your stack)
jj stack-sync

# Push updated stack
jj stack-submit
```

### Manual PR Base

If you need to set a PR's base manually:

```bash
gh pr edit my-branch --base other-branch
```

### My Bookmark Didn't Update

If you're wondering why your bookmark didn't move when you created a new commit, see [Common Mistakes](/guides/common-mistakes/#mistake-2-expecting-bookmarks-to-auto-follow). This is THE most common confusion for Git users transitioning to JJ.
