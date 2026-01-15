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

| Alias | Purpose |
|-------|---------|
| `prv` | View current PR |
| `pro` | Open current PR in browser |
| `prstack` | List bookmarks in stack |
| `sprs` | Create/update stacked PRs |
| `prs` | Generate PR stack summary |
| `uprs` | Update PR comments with stack info |
| `slackstack` | Slack-formatted PR stack |

## Basic Workflow

```bash
# View the PR for your current branch
jj prv

# Open it in the browser
jj pro
```

## Stacked PRs

LazyJJ makes stacked PRs easy. First, create bookmarks for each commit:

```bash
# Create your stack
jj start
jj describe -m "Add database schema"
jj bookmark create db-schema
jj n

jj describe -m "Add user model"
jj bookmark create user-model
jj n

jj describe -m "Add user API"
jj bookmark create user-api
```

Then create/update all PRs at once:

```bash
# Create stacked PRs for all bookmarks
jj sprs
```

This will:
1. Push each bookmark to the remote
2. Create a PR for each bookmark
3. Set the base branch correctly for stacking

## PR Stack Summary

Generate a summary of your PR stack:

```bash
# Markdown format
jj prs

# Output:
# ## PR Stack
#
# - [user-api](https://github.com/...): Add user API
# - [user-model](https://github.com/...): Add user model
# - [db-schema](https://github.com/...): Add database schema
```

Update PR descriptions with the stack summary:

```bash
jj uprs
```

## Slack Integration

Share your PR stack status in Slack:

```bash
jj slackstack

# Output:
# *PR Stack*
#
# :white_check_mark: <url|user-api>: Add user API
# :large_yellow_circle: <url|user-model>: Add user model
# :white_check_mark: <url|db-schema>: Add database schema
```

## Utility Commands

| Alias | Purpose |
|-------|---------|
| `repo` | Get GitHub repo from origin |
| `gh` | Run any gh command in repo context |

```bash
# Get the repo name
jj repo  # -> owner/repo

# Run any gh command
jj gh pr list
jj gh issue create
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
jj sync

# Push updated stack
jj ss
```

### Manual PR Base

If you need to set a PR's base manually:

```bash
gh pr edit my-branch --base other-branch
```
