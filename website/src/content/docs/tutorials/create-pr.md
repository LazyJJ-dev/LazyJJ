---
title: Create a Pull Request
description: Step-by-step guide to creating a PR with LazyJJ
---

This tutorial walks through creating a single pull request using LazyJJ.

## Prerequisites

- [LazyJJ installed](/installation/)
- GitHub CLI (`gh`) installed and authenticated
- A Git repository with a GitHub remote

## Step 1: Start Fresh from Trunk

Begin by syncing with the latest trunk and starting a new commit:

```bash
jj stack-start
```

This command:
1. Fetches the latest changes from the remote
2. Creates a new commit on top of trunk

## Step 2: Make Your Changes

Edit files as usual. In JJ, your working copy **is** a commit, so changes are automatically tracked:

```bash
# Edit files with your favorite editor
vim src/auth.js

# Check what's changed
jj status

# See the diff
jj diff
```

No `git add` needed - all changes are part of your current commit.

## Step 3: Describe Your Commit

Add a commit message describing your changes:

```bash
jj describe -m "feat: Add user authentication"
```

You can run this multiple times to update the message.

## Step 4: Create a Bookmark

PRs need a branch name. Create a bookmark (JJ's term for a branch):

```bash
jj create auth-feature
```

This creates a bookmark pointing at your parent commit (`@-`).

> **Note about Bookmarks vs Branches**: JJ calls them "bookmarks" while GitHub calls them "branches." They're the same thing. Why the different term? JJ bookmarks don't auto-follow like Git branches—you must manually update them. This is THE most common confusion for Git users. See [Common Mistakes](/guides/common-mistakes/#mistake-2-expecting-bookmarks-to-auto-follow) for details.

## Step 5: Push and Create the PR

Push your changes and create a PR in one command:

```bash
jj pr-stack-create
```

This will:
1. Push your bookmark to the remote
2. Create a PR on GitHub (or update if it exists)
3. Open the PR form if it's new

## Step 6: Respond to Feedback

When reviewers request changes:

```bash
# Make your changes
vim src/auth.js

# Changes are automatically in your commit!
# Just push the update
jj stack-submit
```

No need to amend or create fixup commits. Your working copy automatically updates the commit.

## Complete Workflow

Here's the entire flow in one block:

```bash
# Start fresh
jj stack-start

# Make changes
vim src/auth.js
vim src/login.js

# Describe your work
jj describe -m "feat: Add user authentication

- Add auth middleware
- Add login endpoint
- Add session handling"

# Create bookmark for PR
jj create auth-feature

# Push and create PR
jj pr-stack-create
```

## Tips

### Viewing Your PR

```bash
# View PR details in terminal
jj pr-view

# Open PR in browser
jj pr-open
```

### Updating After Review

```bash
# Make requested changes
vim src/auth.js

# Push updates (PR updates automatically)
jj stack-submit
```

### Draft PRs

When creating a PR with `jj pr-stack-create`, you can choose to create it as a draft.

## Next Steps

- Learn to [Create a Stack](/tutorials/create-stack/) of PRs
- See how to [Navigate Your Stack](/tutorials/navigate-stack/)
- Learn about [Syncing with Remote](/tutorials/sync-remote/)
