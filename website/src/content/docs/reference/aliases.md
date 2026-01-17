---
title: Aliases
description: Complete reference for LazyJJ aliases
---

LazyJJ provides aliases that add value beyond built-in JJ commands. For shortcuts, see `lazyjj-shortcuts.toml`.

## Philosophy: Value-Add Over Shortcuts

LazyJJ's approach to aliases:

- **Value-add aliases**: Do something Git or vanilla JJ don't (these are in the main reference)
- **Pure shortcuts**: Just shorter names for existing commands (separate file)

This keeps the main aliases file focused on LazyJJ's unique contributions to the JJ workflow.

## Value-Add Aliases

These aliases add flags or combine commands beyond what JJ provides natively:

### Diff Aliases

| Command | Shortcut | JJ Command | Purpose |
|---------|----------|------------|---------|
| `diff-summary` | `diffs` | `diff --summary --no-pager` | Compact diff summary |
| `diff-files` | `diffls` | `diff --name-only --no-pager` | List changed files only |

### Log Aliases

| Command | JJ Command | Purpose |
|---------|------------|---------|
| `log-short` | `log --limit 10` | Quick log (last 10 commits) |

## Shortcuts

LazyJJ also provides shortcuts via `lazyjj-shortcuts.toml`:

| Shortcut | Command |
|----------|---------|
| `diffs` | `diff-summary` |
| `diffls` | `diff-files` |
| `gf` | `git fetch` |

For stack-related shortcuts (`stack`, `top`, `sync`, etc.), see [Stack Workflow](/reference/stack/).
For GitHub shortcuts (`prv`, `pro`, `sprs`, etc.), see [GitHub Integration](/integrations/github/).

## Examples

```bash
# Using value-add aliases
jj diff-files    # Just file names
jj diff-summary  # Summary of changes
jj log-short     # See recent history (last 10)

# Using shortcuts
jj diffs         # Same as diff-summary
jj diffls        # Same as diff-files
jj gf            # Same as 'jj git fetch'
```

## Customizing Aliases

To add your own aliases or override LazyJJ's, create a file in `~/.config/jj/conf.d/` that sorts after `lazyjj-*`:

```toml
# ~/.config/jj/conf.d/zzz-my-aliases.toml
[aliases]
# Add custom aliases
mylog = ["log", "--limit", "5", "-T", "builtin_log_compact"]

# Override a LazyJJ alias
log-short = ["log", "--limit", "20"]
```
