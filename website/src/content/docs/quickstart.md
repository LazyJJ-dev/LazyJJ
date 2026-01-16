---
title: Quick Start
description: Get productive with LazyJJ in 5 minutes
---

This guide will get you productive with LazyJJ in 5 minutes.

## Your First Commands

After [installing LazyJJ](/installation/), try these commands in any JJ repository:

```bash
# Check status (shortcut: jj st)
jj status

# View recent history (shortcut: jj l)
jj log-short

# View changes (shortcut: jj d)
jj diff
```

## Creating Commits

```bash
# Create a new commit (shortcut: jj n)
jj new

# Edit your changes, then view them
jj diff

# Describe your commit
jj describe -m "Add awesome feature"

# Create another commit
jj new
```

## Working with Stacks

A "stack" is the series of commits from trunk to your current position:

```bash
# View your current stack
jj stack-view

# Navigate to the top of your stack
jj stack-top

# Navigate to the bottom
jj stack-bottom

# Sync your stack with the latest trunk
jj stack-sync
```

## Starting Fresh

```bash
# Fetch latest and start from trunk
jj stack-start
```

## Viewing All Your Work

```bash
# View all your stacks (all mutable commits you own)
jj stacks-all
```

## GitHub Workflow

If you have GitHub CLI (`gh`) installed:

```bash
# View current PR
jj pr-view

# Open PR in browser
jj pr-open

# Create/update stacked PRs
jj pr-stack-create
```

## Next Steps

- Learn all the [aliases](/reference/aliases/)
- Understand [revsets](/reference/revsets/)
- Master the [stack workflow](/reference/stack/)
- Set up [GitHub integration](/integrations/github/)
