---
title: Quick Start
description: Get productive with LazyJJ in 5 minutes
---

This guide will get you productive with LazyJJ in 5 minutes.

## Your First Commands

After [installing LazyJJ](/installation/), try these commands in any JJ repository:

```bash
# Check status (alias for 'jj status')
jj st

# View recent history (alias for 'jj log --limit 10')
jj l

# View changes (alias for 'jj diff')
jj d
```

## Creating Commits

```bash
# Create a new commit (alias for 'jj new')
jj n

# Edit your changes, then view them
jj d

# Describe your commit
jj describe -m "Add awesome feature"

# Create another commit
jj n
```

## Working with Stacks

A "stack" is the series of commits from trunk to your current position:

```bash
# View your current stack
jj stack

# Navigate to the top of your stack
jj top

# Navigate to the bottom
jj bottom

# Sync your stack with the latest trunk
jj sync
```

## Starting Fresh

```bash
# Fetch latest and start from trunk
jj start
```

## Viewing All Your Work

```bash
# View all your stacks (all mutable commits you own)
jj stacks
```

## GitHub Workflow

If you have GitHub CLI (`gh`) installed:

```bash
# View current PR
jj prv

# Open PR in browser
jj pro

# Create/update stacked PRs
jj sprs
```

## Next Steps

- Learn all the [aliases](/reference/aliases/)
- Understand [revsets](/reference/revsets/)
- Master the [stack workflow](/reference/stack/)
- Set up [GitHub integration](/integrations/github/)
