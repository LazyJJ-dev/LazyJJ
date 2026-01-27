---
title: The Operation Log
description: Your safety net - why JJ is safe to experiment with
---

One of JJ's killer features is the **operation log**—a complete history of every action you've taken in your repository. This is your safety net that makes JJ safe to experiment with.

## What is the Operation Log?

Every time you run a JJ command that modifies the repository, JJ creates an **operation** that records:
- What command you ran
- The complete state of the repository before and after
- When it happened
- Any commit changes that resulted

The operation log is not just for commits—it tracks **everything**:
- `jj new` - Creating commits
- `jj edit` - Changing which commit you're working on
- `jj rebase` - Moving commits around
- `jj squash` - Combining commits
- `jj describe` - Updating commit messages
- `jj abandon` - Removing commits
- Even `jj undo` itself!

As one developer put it: "Version control finally entered the 1960s" (a reference to having undo/redo in modern applications).

## Viewing Your Operation History

See what you've done:

```bash
jj op log
```

Output shows each operation:

```
@  a8c4d9e7 user@host 2024-01-15 14:23:19 -08:00
│  rebase commit xyz
│  args: jj rebase -s xyz -d main
○  b7f3a2c1 user@host 2024-01-15 14:20:45 -08:00
│  new empty commit
│  args: jj new -m "Add feature"
○  c9e1b4d3 user@host 2024-01-15 14:15:32 -08:00
│  describe commit abc
│  args: jj describe -m "Update message"
```

Each operation has an ID (like `a8c4d9e7`) that you can use to restore or examine that point in history.

## The Simple Undo

Made a mistake? Undo it:

```bash
jj undo
```

This reverses the last operation. You can run it multiple times:

```bash
jj undo  # Undo last operation
jj undo  # Undo the one before that
jj undo  # Keep going back
```

### What You Can Undo

**Everything**:
- Bad rebase? `jj undo`
- Abandoned the wrong commit? `jj undo`
- Squashed commits by mistake? `jj undo`
- Resolved conflicts wrong? `jj undo`
- Accidentally deleted a bookmark? `jj undo`

There's no limit to what `jj undo` can reverse.

## Time Travel with `jj op restore`

Want to jump to a specific point in history rather than undoing one step at a time?

```bash
# View your operation log
jj op log

# Restore to a specific operation
jj op restore b7f3a2c1
```

This restores your **entire repository state** to that operation—all commits, bookmarks, working copy, everything.

## Real-World Scenarios

### Scenario 1: Bad Rebase

```bash
# Rebase your stack
jj rebase -s stack -d trunk
# Oh no! Conflicts everywhere and I messed it up

# No problem - undo
jj undo
# Back to before the rebase
```

### Scenario 2: Accidentally Abandoned Commits

```bash
# View commits
jj log -r stacks

# Abandon what you thought was an empty commit
jj abandon xyz
# Oh no! That had important work!

# Restore it
jj undo
# The commit is back with all its changes
```

### Scenario 3: Wrong Conflict Resolution

```bash
# Resolve conflicts
jj resolve
# ... make choices ...
# Wait, I resolved that wrong

# Undo the resolution
jj undo
# Conflicts are back, can resolve again
```

### Scenario 4: Experimenting with Stack Reorganization

```bash
# Try a complex rebase
jj rebase -s commit-a -d commit-b
jj squash -r commit-c
jj rebase -s commit-d -d commit-e

# Hmm, that didn't work out how I wanted

# Undo all of it
jj undo
jj undo
jj undo
# Or restore to before you started:
jj op restore <op-id-before-experiment>
```

## Understanding Operation IDs

Each operation gets a unique ID. JJ shows you the ID when you run commands:

```bash
$ jj rebase -s xyz -d main
Rebased 3 commits
Working copy now at: qpvuntsm
Added 0 files, modified 1 files, removed 0 files
Operation ID: a8c4d9e7
```

You can use these IDs with `jj op restore` to return to exact moments in time.

## The Operation Log vs Git's Reflog

Git has a `git reflog` feature, but it's much more limited:

| Git Reflog | JJ Operation Log |
|------------|------------------|
| Tracks HEAD movements only | Tracks every repository change |
| Separate reflog per branch | One unified history |
| Entries expire (default 90 days) | Permanent history |
| Hard to understand output | Clear command history |
| Can't restore complex states | Full state restoration |

In Git, recovering from mistakes requires understanding reachability, detached HEAD states, and manual `git reset`/`git cherry-pick` operations.

In JJ, you just `jj undo` or `jj op restore`.

## Why This Enables Fearless Refactoring

The operation log fundamentally changes how you interact with version control:

**Before (Git mentality)**:
- "Let me carefully plan this rebase"
- "I better create a backup branch just in case"
- "What if I mess up the conflict resolution?"
- Fear leads to avoiding powerful operations

**After (JJ mentality)**:
- "Let me try this rebase and see what happens"
- "I can always undo if it doesn't work"
- "Experiment first, commit to the approach after"
- Safety enables exploration

Developers consistently report being more willing to experiment once they trust `jj undo`.

## Operation Log Limitations

A few things to know:

1. **Operations are local** - They don't sync to remotes. If you clone a repo, you start with a fresh operation log.

2. **Undo works on operations, not time** - If you run three commands quickly, you need three undos (or use `jj op restore`).

3. **Can't undo pushes to remote** - Once you push to GitHub, that's permanent (though you can always force-push corrections).

## Practical Tips

### Before Risky Operations

Check your current operation ID:

```bash
jj op log --limit 1
```

Save that ID. If things go wrong, you can `jj op restore <id>` to get back.

### Viewing Operation Details

See exactly what changed in an operation:

```bash
jj op show a8c4d9e7
```

This shows all commits that were added, modified, or removed.

### Cleaning Old Operations (Advanced)

Operations accumulate over time. To clean up very old operations:

```bash
jj op abandon <old-op-id>
```

This removes operations before that ID. Only do this if you're sure you won't need to restore to those states.

## Next Steps

Now that you trust JJ's safety net:

- Understand the [Mental Model](/guides/mental-model/) of how JJ works
- Read [Common Mistakes](/guides/common-mistakes/) to avoid pitfalls
- Try [First-Class Conflicts](/tutorials/resolve-conflicts/) knowing you can undo

The operation log makes JJ one of the safest version control systems ever created. Experiment freely!
