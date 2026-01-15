---
title: Revsets
description: Revset aliases for querying commits
---

LazyJJ provides revset aliases to make querying commits easier.

## What are Revsets?

Revsets are JJ's query language for selecting commits. They're used with commands like `jj log -r <revset>`.

## LazyJJ Revset Aliases

| Alias | Definition | Purpose |
|-------|------------|---------|
| `trunk` | `trunk()` | The main branch |
| `branch_off` | `fork_point(trunk() \| @)` | Where you diverged from trunk |
| `stack_base` | `roots(branch_off+::@)` | Root commit of current stack |
| `stack` | `stack_base::` | All commits in current stack |
| `stacks` | `mine() & mutable()` | All your work-in-progress |
| `no_description` | `description(exact:'') ~ root() ~ empty()` | Commits needing descriptions |
| `ghbranch` | `heads(::@ & bookmarks())` | Current bookmark for GitHub |

## Examples

```bash
# View your current stack
jj log -r stack

# View all your work-in-progress
jj log -r stacks

# Find commits without descriptions
jj log -r no_description

# See where you diverged from trunk
jj log -r branch_off

# Check which bookmark will be used for GitHub
jj log -r ghbranch
```

## Understanding the Stack Model

LazyJJ's stack concept is built on these revsets:

```
trunk (main)
    │
    └── branch_off (fork point)
            │
            └── stack_base (first commit in stack)
                    │
                    ├── commit 2
                    │
                    └── @ (current position)
```

The `stack` revset selects all commits from `stack_base` to the tips.

## Combining Revsets

You can combine LazyJJ revsets with JJ's operators:

```bash
# Stack commits that are empty
jj log -r "stack & empty()"

# Stack commits with bookmarks
jj log -r "stack & bookmarks()"

# Your stacks excluding current stack
jj log -r "stacks ~ stack"
```

## Customizing Revsets

Add your own revset aliases:

```toml
# ~/.config/jj/conf.d/zzz-my-revsets.toml
[revset-aliases]
# Work in progress on feature X
"wip-x" = "mine() & mutable() & description(substring:'feature-x')"
```
