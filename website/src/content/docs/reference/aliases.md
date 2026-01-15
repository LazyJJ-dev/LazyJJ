---
title: Aliases
description: Complete reference for LazyJJ aliases
---

LazyJJ provides aliases to make common JJ commands faster to type.

## Core Aliases

These are the essential shortcuts everyone needs:

| Alias | Command | Purpose |
|-------|---------|---------|
| `st` | `status` | Quick status check |
| `d` | `diff` | View changes |
| `l` | `log --limit 10` | Quick log (last 10 commits) |
| `ll` | `log` | Full log |
| `n` | `new` | Create new commit |
| `e` | `edit` | Edit a commit |

## Diff Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `diffs` | `diff --summary --no-pager` | Compact diff summary |
| `diffls` | `diff --name-only --no-pager` | List changed files only |

## History Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `hist` | `log --no-pager` | Full history without pager |

## Git Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `gf` | `git fetch` | Fetch from remote |

## Examples

```bash
# Quick workflow
jj st        # Check what's changed
jj d         # See the diff
jj n         # Create new commit
jj l         # See recent history

# Check changed files quickly
jj diffls    # Just file names
jj diffs     # Summary of changes

# Fetch latest
jj gf        # Same as 'jj git fetch'
```

## Customizing Aliases

To add your own aliases or override LazyJJ's, create a file in `~/.config/jj/conf.d/` that sorts after `lazyjj-*`:

```toml
# ~/.config/jj/conf.d/zzz-my-aliases.toml
[aliases]
# Override an existing alias
st = ["status", "--no-pager"]

# Add a new alias
co = ["checkout"]
```
