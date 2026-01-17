---
title: Sync with Remote
description: Keep your stack up-to-date with trunk
---

This tutorial covers syncing your local stack with changes from the remote repository.

## Why Sync?

While you work on your feature, others merge changes to `main`. Syncing:
- Brings in the latest trunk changes
- Rebases your stack on top
- Keeps your PRs mergeable
- Reduces conflicts by staying current

## The Simple Way

One command does everything:

```bash
jj stack-sync
```

This:
1. Fetches the latest changes from the remote
2. Rebases your stack onto the updated trunk
3. Shows you the result

## Step-by-Step Breakdown

If you want more control, do it manually:

```bash
# Fetch latest from remote
jj git fetch

# Rebase your stack onto trunk
jj restack
```

## Handling Conflicts

If syncing creates conflicts, JJ handles them gracefully:

```bash
jj stack-sync
# Output might show: "Commit xyz has conflicts"

# View what has conflicts
jj status

# JJ lets you continue working with conflicts present
# Resolve them when you're ready:
jj resolve
```

Unlike Git, JJ doesn't block you from continuing work when conflicts exist. You can:
- Create new commits on top of conflicted ones
- Resolve conflicts later
- See exactly which commits have conflicts with `jj log`

See the [Conflicts tutorial](/tutorials/resolve-conflicts/) for JJ's first-class conflict handling. This is one of JJ's superpowers—conflicts don't stop you.

### Why Sync is Easier in JJ

**Git workflow**: `pull` → conflicts → **blocked** → resolve → continue

**JJ workflow**: `sync` → conflicts → keep working → resolve when convenient

## After a PR Merges

When someone merges your first PR:

```bash
# Sync pulls in the merge and rebases remaining stack
jj stack-sync

# The merged PR's commit is now on trunk
# Your remaining commits are rebased on top

# Push the updated stack
jj stack-submit
```

## Pushing Your Updated Stack

After syncing, push your changes:

```bash
jj stack-submit
```

This force-pushes your bookmarks to the remote, updating your PRs.

## Complete Sync Workflow

```bash
# Sync with trunk
jj stack-sync

# Check for conflicts
jj status

# If conflicts, resolve them
jj resolve      # Opens your conflict resolution tool

# Push updates
jj stack-submit
```

## Viewing Sync Status

Before syncing, see how far behind you are:

```bash
# View your stack
jj stack-view

# Fetch without rebasing to see what's new
jj git fetch
jj log -r "trunk..@"    # See your commits relative to trunk
```

## Tips

### Sync Early and Often

Don't wait until the end. Regular syncing:
- Keeps conflicts small and manageable
- Ensures your PRs stay up-to-date
- Makes final merge easier

### Automatic Conflict Markers

JJ uses different conflict markers than Git:

```
<<<<<<< Conflict 1 of 1
+++++++ Contents of side #1
your changes
%%%%%%% Changes from base to side #2
-old line
+their changes
>>>>>>> Conflict 1 of 1 ends
```

The `%%%%%%%` section shows what changed in their version, making it easier to understand the conflict.

### Check for Conflicts

After syncing, quickly check if any commits have conflicts:

```bash
jj log -r "stack"    # Conflicted commits are marked
```

## When to Sync

Good times to sync:
- Start of each work session
- Before creating new commits
- Before requesting review
- After a PR in your stack is merged
- When you see "branch out of date" warnings

## Next Steps

- Learn to [Edit Mid-Stack Commits](/tutorials/edit-mid-stack/)
- Check out [Stack Workflow Reference](/reference/stack/)
- See [GitHub Integration](/integrations/github/)
