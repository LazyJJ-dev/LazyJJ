---
title: Understanding JJ's Mental Model
description: The "aha moment" - how JJ is fundamentally different from Git
---

If you're coming from Git, JJ will feel strange at first. But once the mental model "clicks" (typically within 4-8 hours of use), you'll wonder how you ever tolerated Git's complexity. This guide explains the key conceptual shifts that make JJ powerful.

## The "Aha Moment"

The single most important thing to understand about JJ:

**Your working copy IS a commit, not a staging area preparing for a future commit.**

This one insight unlocks everything else about how JJ works.

## Git's Model vs JJ's Model

### Git's Three-Stage Flow

```
Untracked files
    ↓ (git add)
Staged changes
    ↓ (git commit)
Committed
```

In Git, you're always preparing changes to become a commit. You explicitly stage what you want, then commit it, creating a new immutable snapshot.

### JJ's Direct Flow

```
Edit files
    ↓ (automatic!)
Changes in current commit
    ↓ (jj new)
Start next commit
```

In JJ, you're always **inside** a commit. When you edit a file, it immediately becomes part of that commit. No staging, no preparation—you're editing the commit directly.

## What This Means in Practice

### Editing Files Automatically Amends

```bash
# Create a commit
jj new -m "Add authentication"

# Edit some files
vim src/auth.js
vim src/login.js

# Check what changed
jj diff
# Shows: Changes in your current commit

# That's it! The changes are already in the commit.
# No git add, no git commit --amend.
```

Every file edit automatically amends the current commit. This is not a special mode—it's how JJ always works.

### Starting a New Commit with `jj new`

In Git, `git commit` finalizes changes you've staged and prepares for the next commit.

In JJ, `jj new` finalizes your current commit and creates a fresh one to work in:

```bash
jj new -m "Add authentication"
# ... edit files ...

jj new -m "Add tests"
# Previous commit is sealed, now working in new one
# ... edit test files ...
```

Think of `jj new` as "seal this commit and start the next one."

## Changes vs Revisions

JJ distinguishes between two concepts that Git conflates:

- **Change**: A mutable unit of work with a stable **change ID**
- **Revision**: An immutable snapshot (the actual Git commit)

When you edit a commit in JJ:
- The **change ID** stays the same (like `qpvuntsm`)
- The underlying **revision** (Git SHA) changes

This is what enables JJ's "time traveler editing":

```bash
# View your stack
jj log
# @  qpvuntsm user-api "Add user API"
# ○  mwmpwkwk user-model "Add user model"
# ○  trunk

# Edit the user-model commit
jj edit mwmpwkwk

# Make changes
vim src/models/user.js

# JJ automatically:
# 1. Creates new revision for user-model
# 2. Rebases user-api on top
# 3. Keeps the same change IDs
```

The change IDs are your handle to manipulate history. The revisions are implementation details.

## No Staging Area

Git's staging area (the "index") is a persistent state between your working directory and commit history. You explicitly add/remove files to control what goes in the next commit.

JJ has no staging area. Everything in your working directory is automatically part of your current commit.

### Git Workflow

```bash
# Edit files
vim file1.txt file2.txt

# Choose what to commit
git add file1.txt
git commit -m "Update file1"

# file2.txt remains unstaged
```

### JJ Equivalent

```bash
# Edit files
vim file1.txt file2.txt

# Everything is already in current commit
# To split them:
jj split
# Interactive UI lets you choose what stays in current commit
# Rest goes to a new commit
```

In JJ, you split commits after the fact rather than staging before. This feels backwards initially but becomes natural—you can always `jj undo` if you split wrong.

## The Time Traveler Editing Pattern

This is what makes developers rave about JJ:

```bash
# You have a stack of commits
jj log
# @  commit-3 "Add feature"
# ○  commit-2 "Add middleware"
# ○  commit-1 "Add database schema"
# ○  trunk

# Realize you need to fix commit-2
jj edit commit-2

# Make your fix
vim src/middleware.js

# That's it! JJ automatically:
# - Updates commit-2 with your changes
# - Rebases commit-3 on top
# - Handles conflicts if any arise

# Return to the top
jj edit commit-3
# Or: jj stack-top
```

As one developer put it: "It's honestly time traveler stuff. You just go back and edit it. At any time. When you're done, jj automatically rebases all subsequent changes... **IT'S ACTUALLY AMAZING**."

## Why This Model is Better

### No Lost Work

In Git, unsaved or unstaged changes can be lost if you're not careful. `git reset --hard` destroys uncommitted work.

In JJ, everything is always committed. You can `jj edit` any commit in your history—even switch to a different stack—and your work is safe. Use `jj undo` if you make a mistake.

### No Stash Needed

Git users constantly `git stash` to switch contexts:

```bash
git stash
git checkout other-branch
# work...
git checkout original-branch
git stash pop
```

In JJ, your current commit already contains your work. Just `jj edit` a different commit:

```bash
jj edit other-commit
# work...
jj edit back-to-original
# Your previous work is still there!
```

### Amending is Free

In Git, `git commit --amend` is a special operation. You have to remember to use it. If you forget, you create tiny fixup commits.

In JJ, amending is the default. Every file edit amends. You can't forget because it's automatic.

### History Manipulation is Safe

Git's `git rebase -i` is powerful but dangerous. One wrong move and you're detangling a mess.

JJ's equivalent operations (`jj rebase`, `jj squash`, `jj edit`) are safe because:
1. The operation log records every action
2. `jj undo` reverses any operation
3. Descendants rebase automatically

## Next Steps

Now that you understand the mental model:

- Try the [Quick Start](/quickstart/) with this new understanding
- Learn about the [Operation Log](/guides/operation-log/) (your safety net)
- Read [Common Mistakes](/guides/common-mistakes/) to avoid frustration
- See the [Git → JJ Quick Reference](/guides/git-differences/) for command mappings
