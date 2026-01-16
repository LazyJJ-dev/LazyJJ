---
title: Create a Stack
description: Build a stack of commits for stacked PRs
---

This tutorial shows how to create a stack of commits, each becoming its own PR that builds on the previous one.

## Why Stack?

Stacking lets you:
- Break large features into reviewable chunks
- Get early feedback on foundational changes
- Merge PRs incrementally as they're approved
- Keep your PRs small and focused

## Prerequisites

- [LazyJJ installed](/installation/)
- GitHub CLI (`gh`) installed and authenticated
- A Git repository with a GitHub remote

## Step 1: Start from Trunk

Begin with a fresh start from the latest trunk:

```bash
jj stack-start
```

## Step 2: First Commit

Make your first set of changes - typically the foundation that later work builds on:

```bash
# Make your changes
vim src/database/schema.sql
vim src/database/migrations/001_users.sql

# Describe the commit
jj describe -m "Add user database schema"

# Create a bookmark for this PR
jj bookmark-create db-schema

# Start the next commit
jj new
```

## Step 3: Second Commit

Build on the first commit:

```bash
# Make changes that depend on the schema
vim src/models/user.js
vim src/models/user.test.js

# Describe it
jj describe -m "Add user model"

# Create a bookmark
jj bookmark-create user-model

# Start the next commit
jj new
```

## Step 4: Third Commit

Continue the stack:

```bash
# Make changes that use the model
vim src/api/users.js
vim src/api/users.test.js

# Describe it
jj describe -m "Add user API endpoints"

# Create a bookmark
jj bookmark-create user-api
```

## Step 5: View Your Stack

See the full stack:

```bash
jj stack-view
```

Output shows the relationship:

```
@  xyz user-api "Add user API endpoints"
○  abc user-model "Add user model"
○  def db-schema "Add user database schema"
○  trunk
```

## Step 6: Push All PRs

Create PRs for the entire stack at once:

```bash
jj pr-stack-create
```

This creates three PRs:
1. `db-schema` - base PR targeting `main`
2. `user-model` - PR targeting `db-schema`
3. `user-api` - PR targeting `user-model`

## Complete Example

Here's the full workflow:

```bash
# Start fresh
jj stack-start

# First commit - database schema
vim src/database/schema.sql
jj describe -m "Add user database schema"
jj bookmark-create db-schema
jj new

# Second commit - model layer
vim src/models/user.js
jj describe -m "Add user model"
jj bookmark-create user-model
jj new

# Third commit - API layer
vim src/api/users.js
jj describe -m "Add user API endpoints"
jj bookmark-create user-api

# View the stack
jj stack-view

# Push everything
jj pr-stack-create
```

## Viewing Stack with File Changes

To see which files each commit touches:

```bash
jj stack-files
```

## Tips

### Naming Bookmarks

Use descriptive names that indicate the order or relationship:

```bash
jj bookmark-create feature/01-schema
jj bookmark-create feature/02-model
jj bookmark-create feature/03-api
```

### Don't Forget `jj new`

After describing a commit, run `jj new` before starting the next set of changes. Otherwise, you'll keep modifying the same commit.

### View All Your Stacks

If you have multiple features in progress:

```bash
jj stacks-all
```

## After a PR Merges

When a PR in your stack gets merged:

```bash
# Sync with trunk - this rebases your remaining stack
jj stack-sync

# Push the updated stack
jj stack-submit
```

JJ automatically rebases your remaining commits onto the new trunk.

## Next Steps

- Learn to [Navigate Your Stack](/tutorials/navigate-stack/)
- See how to [Edit Mid-Stack Commits](/tutorials/edit-mid-stack/)
- Learn about [Syncing with Remote](/tutorials/sync-remote/)
