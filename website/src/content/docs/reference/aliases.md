---
title: Aliases
description: Complete reference for LazyJJ aliases
---

LazyJJ provides aliases that add value beyond built-in JJ commands. For shortcuts to native commands (`st`, `d`, `n`, `e`, `ll`), see `lazyjj-shortcuts.toml`.

## Value-Add Aliases

These aliases add flags or combine commands beyond what JJ provides natively:

### Diff Aliases

| Command | Shortcut | JJ Command | Purpose |
|---------|----------|------------|---------|
| `diff-summary` | `diffs` | `diff --summary --no-pager` | Compact diff summary |
| `diff-files` | `diffls` | `diff --name-only --no-pager` | List changed files only |

### Log Aliases

| Command | Shortcut | JJ Command | Purpose |
|---------|----------|------------|---------|
| `log-short` | `l` | `log --limit 10` | Quick log (last 10 commits) |
| `log-history` | `hist` | `log --no-pager` | Full history without pager |

### Git Aliases

| Command | Shortcut | JJ Command | Purpose |
|---------|----------|------------|---------|
| `git-fetch` | `gf` | `git fetch` | Fetch from remote |

## Shortcuts

LazyJJ also provides shortcuts to native JJ commands via `lazyjj-shortcuts.toml`:

| Shortcut | JJ Command |
|----------|------------|
| `st` | `status` |
| `d` | `diff` |
| `ll` | `log` |
| `n` | `new` |
| `e` | `edit` |

## Examples

```bash
# Quick workflow using shortcuts
jj st            # Check what's changed
jj d             # See the diff
jj n             # Create new commit
jj l             # See recent history (last 10)

# Using value-add aliases
jj diff-files    # Just file names
jj diff-summary  # Summary of changes
jj log-history   # Full log without pager

# Fetch latest
jj git-fetch     # Same as 'jj git fetch'
```

## Customizing Aliases

To add your own aliases or override LazyJJ's, create a file in `~/.config/jj/conf.d/` that sorts after `lazyjj-*`:

```toml
# ~/.config/jj/conf.d/zzz-my-aliases.toml
[aliases]
# Add custom aliases
mylog = ["log", "--limit", "5", "-T", "builtin_log_compact"]

# Override a shortcut
st = ["status", "--no-pager"]
```
