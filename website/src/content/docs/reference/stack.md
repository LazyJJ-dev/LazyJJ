---
title: Stack Workflow
description: Commands for working with commit stacks
---

LazyJJ provides a complete stack-based workflow for managing commits.

## What is a Stack?

A "stack" is a series of commits from where you diverged from trunk to your current position. This model is perfect for:

- Feature development with multiple logical commits
- Stacked pull requests
- Code review workflows

## Viewing Stacks

| Alias | Purpose |
|-------|---------|
| `stack` | View current stack with trunk context |
| `stackls` | Stack with file changes listed |
| `stacks` | View all your stacks |
| `stacksls` | All stacks with file changes |

```bash
# See your current stack
jj stack

# See what files changed in each commit
jj stackls

# See all your work in progress
jj stacks
```

## Navigation

| Alias | Purpose |
|-------|---------|
| `top` | Jump to top of stack |
| `bottom` | Jump to bottom of stack |

```bash
# Go to the latest commit in your stack
jj top

# Go to the first commit in your stack
jj bottom
```

## Syncing with Trunk

| Alias | Purpose |
|-------|---------|
| `sync` | Fetch and rebase onto trunk |
| `start` | Fetch and start fresh from trunk |
| `restack` | Rebase stack onto trunk (no fetch) |

```bash
# Update your stack with latest trunk
jj sync

# Start a new stack from latest trunk
jj start

# Rebase without fetching
jj restack
```

## Pushing and Bookmarks

| Alias | Purpose |
|-------|---------|
| `ss` | Smart push - push stack to remote |
| `tug` | Move bookmark to parent commit |
| `create` | Create bookmark at parent commit |

```bash
# Push your stack
jj ss

# Move a bookmark to the previous commit
jj tug

# Create a new bookmark at the previous commit
jj create my-feature
```

## Cleanup

| Alias | Purpose |
|-------|---------|
| `gc` | Abandon empty commits in stack |

```bash
# Clean up empty commits
jj gc
```

## Typical Workflow

```bash
# Start fresh from trunk
jj start

# Make your changes, describe them
jj describe -m "Add user authentication"

# Create next commit
jj n

# Make more changes
jj describe -m "Add login form"

# View your stack
jj stack

# Sync with trunk if needed
jj sync

# Push for review
jj ss
```

## Working with Multiple Stacks

```bash
# See all your stacks
jj stacks

# Switch to a specific stack
jj edit <commit-id>

# View that stack
jj stack
```
