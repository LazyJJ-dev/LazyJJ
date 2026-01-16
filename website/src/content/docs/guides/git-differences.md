---
title: Git vs JJ
description: Key differences between Git and Jujutsu
---

If you're coming from Git, Jujutsu (JJ) will feel familiar but with some important differences that make it more powerful and safer to use.

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

```bash
# View conflicts
jj status       # Shows if current commit has conflicts
jj log          # Marks conflicted commits

# Resolve when ready
jj resolve      # Opens conflict resolution tool
```

## Safe Operations with Undo

Every JJ operation can be undone:

```bash
jj undo         # Undo the last operation
jj op log       # See operation history
jj op restore <op-id>  # Restore to any point
```

This makes it safe to experiment. You can always go back.

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

This means:
- No work is ever untracked
- You can switch contexts freely without stashing
- History manipulation is simpler and safer
- The "add, commit, push" dance becomes "describe, new, push"

## Next Steps

- Try the [Quick Start](/quickstart/) guide
- Learn about [Stack Workflow](/reference/stack/)
- See the [Revsets Reference](/reference/revsets/)
