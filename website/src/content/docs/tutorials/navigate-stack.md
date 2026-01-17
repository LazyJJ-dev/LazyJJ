---
title: Navigate Your Stack
description: Moving around within your stack of commits
---

This tutorial covers navigating between commits in your stack.

## Viewing Your Stack

First, understand where you are:

```bash
jj stack-view
```

Output shows your position (`@`) and all commits:

```
@  xyz user-api "Add user API endpoints"
○  abc user-model "Add user model"
○  def db-schema "Add user database schema"
○  trunk
```

The `@` symbol shows your current position.

## Jump to Top

Go to the newest commit in your stack:

```bash
jj stack-top
```

Use this after editing a mid-stack commit to return to where you were.

## Edit Any Commit

Jump to a specific commit using its change ID:

```bash
# From jj stack-view, note the change ID (like "abc")
jj edit abc
```

Now your working copy is that commit. Any changes you make will modify it directly.

## See All Your Stacks

If you have multiple features in progress:

```bash
jj stacks-all
```

This shows all your mutable commits across all stacks.

## Checking Where You Are

Quick ways to see your current position:

```bash
# Full status
jj status

# Just the log showing current position
jj log-short
```

## Navigation Example

Let's say you need to fix something in the middle of your stack:

```bash
# View stack to find the commit
jj stack-view

# Output:
# @  xyz user-api "Add user API endpoints"
# ○  abc user-model "Add user model"
# ○  def db-schema "Add user database schema"
# ○  trunk

# Edit the user-model commit
jj edit abc

# Make your changes
vim src/models/user.js

# Changes are automatically in that commit!
# JJ rebases xyz (user-api) automatically

# Go back to top
jj stack-top
```

## Understanding the Stack Model

In JJ, you're always "inside" a commit. When you navigate:

- **`jj edit xyz`** - You're now editing commit `xyz`
- Any file changes modify `xyz` directly
- Commits above `xyz` are automatically rebased

### What Navigation Means

- **In Git**: Checking out branches, switching between working trees
- **In JJ**: Entering a commit to edit it directly

This is different from Git where you'd need to:
1. Checkout the branch
2. Make changes
3. Commit --amend
4. Rebase dependent branches

JJ does all of this automatically. See the [Mental Model guide](/guides/mental-model/) for deeper explanation.

## Working with Multiple Stacks

To switch between different feature stacks:

```bash
# See all your work
jj stacks-all

# Edit a commit from a different stack
jj edit <change-id-from-other-stack>

# View just that stack
jj stack-view
```

## Tips

### Use Tab Completion

JJ supports tab completion for change IDs. Type a few characters and press Tab.

### Short Change IDs

Change IDs are unique, so you only need enough characters to identify them:

```bash
jj edit xy    # Works if "xy" uniquely identifies a commit
```

**Tip**: Change IDs are visible in `jj log` output. The highlighted first few characters are usually enough to uniquely identify a commit.

### Visual Stack View

For a detailed view with file changes:

```bash
jj stack-files
```

## Next Steps

- Learn to [Edit Mid-Stack Commits](/tutorials/edit-mid-stack/)
- See how to [Sync with Remote](/tutorials/sync-remote/)
- Check out [Stack Workflow Reference](/reference/stack/)
