---
title: Edit Mid-Stack Commits
description: Make changes to commits in the middle of your stack
---

> **This is the workflow Git makes painful and JJ makes trivial.**

This tutorial shows how to modify commits that aren't at the top of your stack—a common need when responding to PR feedback.

## The Scenario

You have a stack of three commits:

```
@  xyz user-api "Add user API endpoints"
○  abc user-model "Add user model"
○  def db-schema "Add user database schema"
```

A reviewer requests changes to the `user-model` commit (abc). Here's how to handle it.

## Step 1: Navigate to the Commit

Use `jj edit` with the change ID:

```bash
jj edit abc
```

Now your working copy is the `user-model` commit.

## Step 2: Make Your Changes

Edit files normally:

```bash
vim src/models/user.js
vim src/models/user.test.js
```

**There's no staging or amending needed.** In JJ, your working copy *is* the commit. Changes are automatically part of it.

## Step 3: Verify Changes

Check that your changes are in:

```bash
jj diff      # See changes in current commit
jj status    # See overall status
```

## Step 4: Return to Top

Go back to the top of your stack:

```bash
jj stack-top
```

## Step 5: Push Updates

Push your updated stack:

```bash
jj stack-submit
```

All PRs in the stack will be updated.

## What Happens Automatically

When you edit a mid-stack commit, JJ automatically rebases all dependent commits, adjusts bookmark pointers, and detects conflicts. **This is JJ's killer feature** — no `git rebase -i` / `--continue` dance needed.

## Complete Example

```bash
# View your stack
jj stack-view
# @  xyz user-api "Add user API endpoints"
# ○  abc user-model "Add user model"
# ○  def db-schema "Add user database schema"

# Edit the middle commit
jj edit abc

# Make your changes
vim src/models/user.js

# Check the diff
jj diff

# Return to top
jj stack-top

# View updated stack - notice xyz has been rebased
jj stack-view

# Push all updates
jj stack-submit
```

## Handling Conflicts

If your changes conflict with later commits:

```bash
# After editing a mid-stack commit
jj stack-top
jj status
# May show: "Commit xyz has conflicts"

# View which commits have conflicts
jj log -r "stack"

# Navigate to the conflicted commit
jj edit xyz

# Resolve conflicts
jj resolve

# Push updates
jj stack-submit
```

**What if my edit creates conflicts?** See the [Conflicts tutorial](/tutorials/resolve-conflicts/) for details on JJ's first-class conflict handling. Unlike Git, conflicts don't block you—you can keep working and resolve them later.

## Editing Multiple Commits

If you need to edit several commits:

```bash
# Edit first commit
jj edit abc
vim src/models/user.js

# Edit another commit
jj edit def
vim src/database/schema.sql

# Return to top
jj stack-top

# Push everything
jj stack-submit
```

## Tips

### Check the Diff Before Pushing

After editing, verify your changes:

```bash
# See all changes in the stack relative to trunk
jj diff -r "trunk..@"

# Or see changes in specific commit
jj diff -r "abc"
```

### Use Status to Confirm

```bash
jj status
```

Shows:
- Current commit
- Any pending changes
- Conflict status

### Don't Forget to Push

After editing mid-stack, your remote PRs are out of date:

```bash
jj stack-submit   # Updates all PRs
```

## Next Steps

- Learn about [Syncing with Remote](/tutorials/sync-remote/)
- See [Stack Workflow Reference](/reference/stack/)
- Check out [GitHub Integration](/integrations/github/)
