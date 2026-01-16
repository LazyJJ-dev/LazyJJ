---
title: Working with Conflicts
description: First-class conflicts - a fundamentally different approach
---

One of JJ's most revolutionary features is how it handles conflicts. Unlike Git where conflicts block your workflow, JJ treats conflicts as **first-class data** that you can commit, work around, and resolve whenever convenient.

## How Conflicts Work in JJ

In Git, conflicts are errors that halt operations until resolved.

In JJ, conflicts are just another state:
- ✅ You can commit conflicted files
- ✅ You can create new commits on top of conflicts
- ✅ You can resolve conflicts later—or never
- ✅ Resolving once propagates through stacks

Research shows 15 out of 20 major JJ resources highlight this as a transformative feature.

## Creating a Conflict (Example)

Let's deliberately create a conflict to see how JJ handles it:

```bash
# Start from main
jj new main -m "Feature A"

# Create a file with version A
echo "version A" > file.txt

# Create another commit that conflicts
jj new -m "Feature B"
echo "version B" > file.txt

# JJ creates a conflict in the current commit (@)
jj status
# Shows: "file.txt has conflicts"
```

What happened:
1. Feature A set `file.txt` to "version A"
2. Feature B tried to change it to "version B"
3. JJ recorded both versions as conflicting

## Living with Conflicts

Here's what makes JJ revolutionary: **you can keep working**.

```bash
# You have a conflict
jj status
# "file.txt has conflicts"

# But you can create new work anyway!
jj new -m "Feature C"
vim other-file.txt  # Work on something else

# View your stack
jj log
# @  Feature C
# ○  Feature B (has conflicts)
# ○  Feature A
# ○  main
```

In Git, the conflict would halt everything. In JJ, Feature B is marked as conflicted, but you're free to continue.

## Viewing Conflicts

See which commits have conflicts:

```bash
# Check current commit
jj status

# View all commits - conflicted ones are marked
jj log -r stack

# See the conflict markers
cat file.txt
```

JJ's conflict markers are more informative than Git's:

```
<<<<<<< Conflict 1 of 1
+++++++ Contents of side #1
version B
%%%%%%% Changes from base to side #2
-version A
+version B
>>>>>>> Conflict 1 of 1 ends
```

The `%%%%%%%` section shows what changed from the base—helping you understand both sides of the conflict.

## Conflict Propagation Through Stacks

This is where JJ's approach becomes powerful: **conflicts propagate through descendant commits**.

```bash
# Create a stack
jj new main -m "Database schema"
echo "table users" > schema.sql

jj new -m "Add auth"
echo "auth code" > auth.js

jj new -m "Add UI"
echo "ui code" > ui.js

# Go back and edit database schema
jj edit <schema-commit>
echo "DIFFERENT table users" > schema.sql

# This creates a conflict in schema.sql
# The conflict propagates to descendants if they touched the same file

# Go to the top
jj stack-top
jj log -r stack
# Shows which commits inherited conflicts
```

**The key insight**: Once you resolve the conflict in the base commit, JJ automatically updates all descendants.

As one developer exclaimed: "YOU JUST FIX THE CONFLICT ONCE, FOR ALL YOUR PULL REQUESTS. IT'S ACTUALLY AMAZING." (Sandy Maguire)

## Resolving Conflicts

When you're ready to resolve (or when you need to—like before pushing to CI):

```bash
# Navigate to the conflicted commit
jj edit <conflicted-commit-id>

# Open the conflict resolver
jj resolve
```

This opens your configured merge tool (like `vimdiff`, `meld`, or `vscode`) showing:
- Base version
- Your version
- Their version
- Merged result

Make your choices and save. JJ automatically:
1. Updates the commit to mark the conflict as resolved
2. Rebases all descendant commits
3. Propagates the resolution through the stack

## When to Resolve Conflicts

In Git, you must resolve immediately. In JJ, you have options:

### Resolve Now

When you want clean history for pushing:

```bash
# Sync brings in changes that conflict
jj stack-sync

# Resolve before pushing
jj resolve
jj stack-submit
```

### Resolve Later

When working on multiple things and conflicts don't block you:

```bash
# Conflict in commit A
jj status
# "file.txt has conflicts"

# Keep working on commit B
jj new -m "Unrelated feature"
vim other-file.js
# No problem!

# Resolve commit A when convenient
jj edit <commit-A>
jj resolve
```

### Resolve Never

If a commit will be squashed or abandoned:

```bash
# Experimental commit with conflicts
jj new -m "Try approach X"
# ... conflicts ...

# Decide not to use it
jj abandon @
# Conflict gone with the commit
```

## Example: Editing Mid-Stack Creates Conflict

A common scenario:

```bash
# You have a stack
jj log
# @  commit-3 "Add API"
# ○  commit-2 "Add models"
# ○  commit-1 "Add database schema"
# ○  main

# Edit the middle commit
jj edit commit-2
vim src/models.js  # Make breaking changes

# This might conflict with commit-3 since it uses the models
# JJ automatically rebases commit-3 and marks conflicts if any

# Go to commit-3 to see
jj edit commit-3
jj status
# May show conflicts if your changes to models break the API

# Resolve
jj resolve
# Fix the conflicts in the API to match new model

# Done! The stack is consistent
```

## Conflict Resolution Tips

### Use `jj undo` for Bad Resolutions

Made the wrong choice while resolving?

```bash
# Resolved conflicts
jj resolve
# ... made wrong choices ...

# Undo the resolution
jj undo
# Conflict state restored, can resolve again
```

### LazyJJ's Claude Integration

If you have Claude CLI set up:

```bash
# AI-assisted conflict resolution
jj claude-resolve
```

Claude will help resolve conflicts by understanding both sides and suggesting resolutions.

### Preview Conflicts Before Resolving

See the conflict markers without opening the resolver:

```bash
cat conflicted-file.txt
```

This lets you understand the conflict before deciding whether to resolve now or later.

## Conflicts in Stacked PRs

A killer workflow:

```bash
# You have 3 stacked PRs
jj log
# @  PR-3 "Add UI"
# ○  PR-2 "Add models"
# ○  PR-1 "Add database schema"
# ○  main

# Main gets updated, conflicts with PR-1
jj stack-sync
# PR-1 now has conflicts

# Resolve PR-1
jj edit <PR-1-commit>
jj resolve
# Fix conflicts

# Go back to top
jj stack-top

# Push updates
jj stack-submit
```

**What JJ did automatically**:
1. Marked PR-1 as conflicted when syncing
2. Let you keep working on PR-3 despite PR-1's conflicts
3. When you resolved PR-1, rebased PR-2 and PR-3
4. Propagated the resolution through the entire stack

In Git/Graphite, you'd resolve PR-1, then manually rebase PR-2, resolve its conflicts, manually rebase PR-3, resolve its conflicts. In JJ, one resolution propagates.

## Why This is Better Than Git

| Git | JJ |
|-----|-----|
| Conflicts block operations | Conflicts are just data |
| Must resolve before continuing | Can work on other commits |
| Rebase stops at each conflict | Records all conflicts, resolves when ready |
| Resolve same conflict in each branch | Resolve once, propagates to descendants |
| Fear of complex rebases | Confident in stack manipulation |

## Common Questions

### "Can I push conflicted commits to GitHub?"

Technically yes (JJ will push the conflict markers), but your CI will likely fail. Best practice: resolve before pushing.

### "What if I want to see all conflicted commits?"

```bash
jj log -r "conflict()"
```

This shows only commits with conflicts.

### "Can I resolve conflicts differently in different branches?"

If branches diverged before the conflict, yes—each has its own conflict state. But in a stack, resolving the base propagates forward.

### "What if Claude's resolution is wrong?"

```bash
jj undo  # Undo Claude's resolution
jj resolve  # Resolve manually
```

The operation log makes experimentation safe.

## Next Steps

Now that you understand first-class conflicts:

- Learn about [Mid-Stack Editing](/tutorials/edit-mid-stack/) - conflict-creating operations
- Read [Syncing with Remote](/tutorials/sync-remote/) - when conflicts commonly occur
- See the [Operation Log](/guides/operation-log/) - your safety net for resolution mistakes
- Understand the [Mental Model](/guides/mental-model/) - why this approach makes sense

First-class conflicts are one of JJ's superpowers. Embrace them!
