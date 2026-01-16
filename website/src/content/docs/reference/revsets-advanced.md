---
title: Advanced Revsets
description: Complex revset queries and LazyJJ aliases
---

This covers advanced revset usage in JJ. For basics, see the [Quick Start guide](/quickstart/#basic-revsets-youll-use-daily).

## What are Revsets?

Revsets are JJ's query language for selecting commits. They're used with commands like `jj log -r <revset>`.

**Daily basics** (covered in Quick Start):
- `@` - Current commit
- `@-` - Parent of current
- `main..@` - Commits between main and current
- `stack` - Your current stack (LazyJJ alias)

**This guide** covers LazyJJ's custom aliases and advanced combinations for complex queries.

## When You Need Advanced Revsets

Most daily work uses simple revsets: `@`, `@-`, `stack`, `stacks`.

Advanced revsets are useful for:
- **Complex rebasing**: Moving multiple commits with specific criteria
- **Bulk operations**: Finding and modifying many commits at once
- **Custom automation**: Scripts that manipulate commit history
- **Debugging**: Finding commits that match specific patterns

If you're doing routine stack work, stick to the basics in the Quick Start.

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

## Basic Examples

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

## Advanced Use Cases

### Find All Commits Touching Specific Files

```bash
# All my commits touching auth code
jj log -r "file(src/auth) & mine()"

# Commits in current stack that modified tests
jj log -r "stack & file(glob:**/*test*.js)"

# Any commit that changed package.json
jj log -r "file(package.json)"
```

### Bulk Operations on Commits

```bash
# Squash all empty commits in stack
jj squash -r "stack & empty()"

# See all commits without descriptions
jj log -r no_description

# Abandon all empty commits
jj abandon "empty() & mine()"
```

### Complex Stack Queries

```bash
# All your stacks except current one
jj log -r "stacks ~ stack"

# Commits in stack that have bookmarks
jj log -r "stack & bookmarks()"

# All mutable commits you own (all WIP)
jj log -r stacks

# Commits in stack that conflict
jj log -r "stack & conflict()"
```

### Time-Based Queries

```bash
# My commits from today
jj log -r "mine() & committer_date(after:'today')"

# Commits in last week
jj log -r "mine() & committer_date(after:'1 week ago')"

# Old branches I forgot about
jj log -r "mine() & mutable() & committer_date(before:'1 month ago')"
```

## Customizing Revsets

Add your own revset aliases:

```toml
# ~/.config/jj/conf.d/zzz-my-revsets.toml
[revset-aliases]
# Work in progress on feature X
"wip-x" = "mine() & mutable() & description(substring:'feature-x')"

# All commits touching database code
"db-changes" = "file(glob:**/db/**) & mine()"

# Recent commits (last 7 days)
"recent" = "mine() & committer_date(after:'1 week ago')"

# Commits ready for review (have bookmarks, not empty)
"ready" = "mine() & bookmarks() & ~empty()"
```

## Next Steps

- Review [Quick Start](/quickstart/#basic-revsets-youll-use-daily) for daily-use revsets
- See [JJ's official revset docs](https://jj-vcs.github.io/jj/latest/revsets/) for complete syntax
- Check [Stack Workflow](/reference/stack/) for stack-specific commands
