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

## Why Stacks Work Better in JJ

Unlike Git or Graphite, stacks are **native** to JJ's model:

- **Git**: Branches fight the stacking workflow. Rebasing is manual and error-prone. You constantly juggle branch names and worry about detached HEAD states.
- **Graphite**: Stacks are metadata layered on top of Git. Break the discipline (one commit per branch), and the stack breaks. The "stack" is actually a queue fighting Git's branch model.
- **JJ**: Stacks are the natural structure of the commit graph. Edit any commit, descendants automatically rebase. Change IDs provide stable handles. It's how JJ works, not a layer on top.

Research insight: Graphite's "stack" metaphor struggles because Git's branch model wasn't designed for it. JJ's change-based model makes stacking natural.

For detailed understanding, see:
- [Mental Model guide](/guides/mental-model/) - Why JJ's approach works
- [Common Mistakes](/guides/common-mistakes/) - Pitfalls to avoid

## Viewing Stacks

| Command | Shortcut | Purpose |
|---------|----------|---------|
| `stack-view` | `stack` | View current stack with trunk context |
| `stack-files` | `stackls` | Stack with file changes listed |
| `stacks-all` | `stacks` | View all your stacks |
| `stacks-all-files` | `stacksls` | All stacks with file changes |

```bash
# See your current stack
jj stack-view

# See what files changed in each commit
jj stack-files

# See all your work in progress
jj stacks-all
```

## Navigation

| Command | Shortcut | Purpose |
|---------|----------|---------|
| `stack-top` | `top` | Jump to top of stack |
| `stack-bottom` | `bottom` | Jump to bottom of stack |

```bash
# Go to the latest commit in your stack
jj stack-top

# Go to the first commit in your stack
jj stack-bottom
```

## Syncing with Trunk

| Command | Shortcut | Purpose |
|---------|----------|---------|
| `stack-sync` | `sync` | Fetch and rebase onto trunk |
| `stack-start` | `start` | Fetch and start fresh from trunk |
| `stack-rebase` | `restack` | Rebase stack onto trunk (no fetch) |

```bash
# Update your stack with latest trunk
jj stack-sync

# Start a new stack from latest trunk
jj stack-start

# Rebase without fetching
jj stack-rebase
```

## Pushing and Bookmarks

| Command | Shortcut | Purpose |
|---------|----------|---------|
| `stack-submit` | `ss` | Smart push - push stack to remote |
| `bookmark-tug` | `tug` | Move bookmark to parent commit |
| `bookmark-create` | `create` | Create bookmark at parent commit |

```bash
# Push your stack
jj stack-submit

# Move a bookmark to the previous commit
jj bookmark-tug

# Create a new bookmark at the previous commit
jj bookmark-create my-feature
```

## Cleanup

| Command | Shortcut | Purpose |
|---------|----------|---------|
| `stack-gc` | `gc` | Abandon empty commits in stack |

```bash
# Clean up empty commits
jj stack-gc
```

## Typical Workflow

```bash
# Start fresh from trunk
jj stack-start

# Make your changes, describe them
jj describe -m "Add user authentication"

# Create next commit
jj new

# Make more changes
jj describe -m "Add login form"

# View your stack
jj stack-view

# Sync with trunk if needed
jj stack-sync

# Push for review
jj stack-submit
```

## Working with Multiple Stacks

```bash
# See all your stacks
jj stacks-all

# Switch to a specific stack
jj edit <commit-id>

# View that stack
jj stack-view
```
