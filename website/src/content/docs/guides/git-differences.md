---
title: Git vs JJ
description: Key differences between Git and Jujutsu
---

> "I became comfortable enough with jj to replace git entirely in **one day**."
> — Hacker News community member

If you're coming from Git, Jujutsu (JJ) will feel familiar but with some important differences that make it more powerful and safer to use. Most developers report a learning curve of 4-8 hours before things "click."

## No Staging Area

In Git, you explicitly stage changes before committing:

```bash
# Git workflow
git add file.txt
git commit -m "message"
```

In JJ, there's no staging area. Your working copy *is* the commit. Changes are automatically part of your current commit:

```bash
# JJ workflow
# ... edit files ...
jj describe -m "message"  # Describe what's already there
jj new                    # Start a new commit
```

This means you never lose work - everything is always tracked.

## Commits Are Mutable

In Git, commits are immutable. To change a commit, you create a new one (amend, rebase).

In JJ, commits are mutable by default. You can edit any commit in your history:

```bash
# Edit a commit in your stack
jj edit <change-id>
# ... make changes ...
# Changes are automatically applied
# JJ automatically rebases dependent commits
```

## Anonymous Branches

Git requires branch names for everything. JJ uses "change IDs" - short identifiers for each commit:

```bash
# Git - must name branches
git checkout -b feature-branch

# JJ - branches (bookmarks) are optional
jj new           # Just create a new commit
jj describe -m "Add feature"
```

Bookmarks (JJ's term for branches) are only needed when you want to push to a remote or create PRs.

## First-Class Conflict Handling

In Git, conflicts block your workflow. You must resolve them immediately.

In JJ, conflicts are just another state. You can:
- Continue working with conflicts present
- Commit changes on top of conflicted commits
- Resolve conflicts later
- See exactly which commits have conflicts

**Even better**: When you edit a mid-stack commit and create conflicts, you resolve them once and JJ automatically propagates the resolution to all descendant commits. As one developer exclaimed: "YOU JUST FIX THE CONFLICT ONCE, FOR ALL YOUR PULL REQUESTS. IT'S ACTUALLY AMAZING."

```bash
# View conflicts
jj status       # Shows if current commit has conflicts
jj log          # Marks conflicted commits

# Work on something else despite conflicts
jj new -m "Other feature"
vim other-file.js  # Keep working!

# Resolve when ready
jj resolve      # Opens conflict resolution tool
```

Learn more: [Working with Conflicts](/tutorials/resolve-conflicts/)

## Safe Operations with Undo

Every JJ operation can be undone:

```bash
jj undo         # Undo the last operation
jj op log       # See operation history
jj op restore <op-id>  # Restore to any point
```

This makes it safe to experiment. You can always go back.

### The Operation Log vs Git Reflog

Git has `git reflog`, but it's much more limited:

| Git Reflog | JJ Operation Log |
|------------|------------------|
| Tracks HEAD movements only | Tracks every repository change |
| Separate reflog per branch | One unified history |
| Entries expire (90 days) | Permanent history |
| Hard to understand | Clear command history |
| Can't restore complex states | Full state restoration |

JJ's operation log is like having comprehensive undo/redo for your entire repository. Research shows this is mentioned in 14 out of 20 major JJ guides as a transformative feature.

Learn more: [Operation Log guide](/guides/operation-log/)

## Revsets for Querying History

JJ has a powerful query language called "revsets" for selecting commits:

```bash
# Select commits
jj log -r "trunk..@"      # Commits between trunk and here
jj log -r "mine()"        # Your commits
jj log -r "stack"         # Current stack (LazyJJ alias)

# Combine with operations
jj rebase -s "stack" -d trunk   # Rebase entire stack
```

## Command Comparison

| Git | JJ | Notes |
|-----|-----|-------|
| `git status` | `jj status` | Same concept |
| `git diff` | `jj diff` | Same concept |
| `git log` | `jj log` | JJ shows graph by default |
| `git add && git commit` | `jj describe && jj new` | No staging needed |
| `git commit --amend` | (automatic) | Working copy always amends |
| `git checkout -b` | `jj new` | Branches optional |
| `git checkout` | `jj edit` | Edit any commit |
| `git rebase -i` | `jj rebase` / `jj squash` | Simpler commands |
| `git stash` | (not needed) | Just `jj new` |
| `git cherry-pick` | `jj duplicate` | Copy commits |
| `git reset --hard` | `jj undo` | Safer recovery |

## Mental Model Shift

The key insight is that JJ treats your **working copy as a commit**. You're always working "inside" a commit, not preparing changes for a future commit.

As one developer put it: "It's honestly time traveler stuff. You just go back and edit it. At any time. When you're done, jj automatically rebases all subsequent changes... **IT'S ACTUALLY AMAZING**."

This means:
- No work is ever untracked
- You can switch contexts freely without stashing
- History manipulation is simpler and safer
- The "add, commit, push" dance becomes "describe, new, push"

### The Learning Curve

Research across 20+ guides shows a consistent pattern:
- **Hours 1-4**: Awkwardness. Git muscle memory fights you. "This feels wrong."
- **Hours 4-8**: The "click." Suddenly the model makes sense. "Oh, NOW I get it."
- **After 8 hours**: Conversion. "I'll never go back to Git."

Give yourself time. The investment is worth it.

### Common Git User Confusions

**"Where's git stash?"**
→ Not needed. Your current commit already has your work. Just `jj edit <other-commit>` to switch contexts. Return with `jj edit <original>` and your work is still there.

**"How do I stage files?"**
→ You don't. Working copy is the commit. Files are automatically included. To split changes later, use `jj split`.

**"Why didn't my bookmark move?"**
→ JJ bookmarks don't auto-follow like Git branches. You must manually `jj bookmark set <name>`. This is THE most common confusion for Git users. See [Common Mistakes](/guides/common-mistakes/#mistake-2-expecting-bookmarks-to-auto-follow) for details.

## Next Steps

- Try the [Quick Start](/quickstart/) guide
- Learn about [Stack Workflow](/reference/stack/)
- See the [Revsets Reference](/reference/revsets/)
