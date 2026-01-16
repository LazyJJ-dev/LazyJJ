---
title: Graphite Migration
description: Command cheatsheet for Graphite users moving to LazyJJ
---

This guide maps Graphite CLI commands to their LazyJJ equivalents. If you're familiar with Graphite, you'll be productive with LazyJJ quickly.

## Command Cheatsheet

### Viewing Your Stack

| Graphite | LazyJJ | Description |
|----------|--------|-------------|
| `gt log` | `jj stack-view` | View current stack |
| `gt log short` / `gt ls` | `jj stacks-all` | View all your stacks |
| `gt branch` | `jj log -r @` | Show current commit |

### Creating and Modifying

| Graphite | LazyJJ | Description |
|----------|--------|-------------|
| `gt create -m "msg"` | `jj describe -m "msg" && jj new` | Create named commit |
| `gt create -am "msg"` | `jj describe -m "msg" && jj new` | Stage all + create |
| `gt modify` | (automatic) | Amend current commit |
| `gt modify -a` | (automatic) | Stage all + amend |
| `gt modify -c` | `jj new && jj describe` | Add new commit to branch |

**Key difference:** In JJ, your working copy automatically amends the current commit. There's no explicit "modify" step needed.

### Syncing and Submitting

| Graphite | LazyJJ | Description |
|----------|--------|-------------|
| `gt sync` | `jj stack-sync` | Fetch + rebase onto trunk |
| `gt submit` | `jj stack-submit` | Push current stack |
| `gt submit --stack` / `gt ss` | `jj stack-submit` | Push entire stack |

### Navigating

| Graphite | LazyJJ | Description |
|----------|--------|-------------|
| `gt checkout` / `gt co` | `jj edit` | Switch to commit |
| `gt up` / `gt u` | (see below) | Move up one |
| `gt down` / `gt d` | (see below) | Move down one |
| `gt top` / `gt t` | `jj stack-top` | Go to top of stack |
| `gt bottom` / `gt b` | `jj stack-bottom` | Go to bottom of stack |

**Note:** JJ doesn't have direct "up/down one commit" commands because its commit model is different. Use `jj edit <change-id>` to jump to any commit, or `jj stack-top` / `jj stack-bottom` to go to the ends.

### Reorganizing

| Graphite | LazyJJ | Description |
|----------|--------|-------------|
| `gt fold` | `jj squash` | Squash into parent |
| `gt squash` | `jj squash --keep-emptied` | Squash commits in branch |
| `gt split` | `jj split` | Split commit into multiple |
| `gt reorder` | `jj rebase` | Reorder commits |
| `gt move` | `jj rebase -r X -d Y` | Move commit to new parent |

### Recovery

| Graphite | LazyJJ | Description |
|----------|--------|-------------|
| `gt undo` | `jj undo` | Undo last operation |
| (none) | `jj op log` | View operation history |
| (none) | `jj op restore <id>` | Restore to any point |

## Key Conceptual Differences

### No Staging Area

In Graphite/Git, you stage changes then commit. In JJ, your working copy **is** the commit:

```bash
# Graphite way
gt add file.txt
gt modify

# JJ way - just edit files, they're automatically part of current commit
# ... edit file.txt ...
# Done! Changes are already in your commit
```

### Change IDs vs Branch Names

Graphite requires naming every branch. JJ identifies commits by change IDs:

```bash
# View your stack - notice the change IDs like "xyz"
jj stack-view

# Reference commits by their change ID
jj edit xyz
jj squash --from xyz
```

You only need bookmarks (JJ's branches) when creating PRs.

### Automatic Rebasing

When you edit a commit in JJ, dependent commits are automatically rebased:

```bash
# Edit a mid-stack commit
jj edit xyz

# ... make changes ...
# JJ automatically rebases everything above xyz
```

No manual `gt restack` needed.

### Conflicts as State

In JJ, conflicts don't block you:

```bash
# You can continue working even with conflicts
jj new               # Create new commit on top
jj stack-view        # See which commits have conflicts
jj resolve           # Resolve when ready
```

## Common Workflows

### Start New Feature

```bash
# Graphite
gt sync
gt create -am "Add feature"

# LazyJJ
jj stack-start       # Fetches and starts from trunk
# ... make changes ...
jj describe -m "Add feature"
```

### Create Stacked PRs

```bash
# Graphite
gt create -am "First change"
gt create -am "Second change"
gt submit --stack

# LazyJJ
# ... make first changes ...
jj describe -m "First change"
jj bookmark-create first-change
jj new
# ... make second changes ...
jj describe -m "Second change"
jj bookmark-create second-change
jj pr-stack-create    # Creates/updates all PRs
```

### Edit Mid-Stack Commit

```bash
# Graphite
gt checkout branch_name
# ... make changes ...
gt modify -a
gt submit

# LazyJJ
jj edit xyz          # Use change ID from jj stack-view
# ... make changes (automatic!) ...
jj stack-top         # Go back to top
jj stack-submit      # Push updates
```

### Sync and Rebase

```bash
# Graphite
gt sync

# LazyJJ
jj stack-sync
```

## Shortcuts Comparison

Both tools provide shortcuts! Here are some familiar ones:

| Graphite | LazyJJ | Command |
|----------|--------|---------|
| `gt ss` | `jj ss` | Submit stack |
| `gt c` | - | Create (use `jj describe && jj new`) |
| `gt m` | - | Modify (automatic in JJ) |
| `gt t` | `jj top` | Go to top |
| `gt b` | `jj bottom` | Go to bottom |

## Next Steps

- Try the [Create a Stack](/tutorials/create-stack/) tutorial
- Learn about [Navigating Stacks](/tutorials/navigate-stack/)
- See [Syncing with Remote](/tutorials/sync-remote/)
