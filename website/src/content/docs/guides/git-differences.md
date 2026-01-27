---
title: Git → JJ Quick Reference
description: Key differences between Git and Jujutsu at a glance
---

If you're coming from Git, this page is your quick reference for the differences that matter most. For the full conceptual explanation, see the [Mental Model guide](/guides/mental-model/).

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

## Key Differences

| Concept | Git | JJ |
|---------|-----|-----|
| Working copy | Prepares a future commit | **Is** the commit |
| Staging area | Explicit `git add` | None — automatic |
| Commits | Immutable | Mutable by default |
| Branches | Required, auto-follow | Optional "bookmarks," manual |
| Conflicts | Block workflow | First-class data — [details](/tutorials/resolve-conflicts/) |
| Undo | Limited `git reflog` | Full [operation log](/guides/operation-log/) |
| History editing | Dangerous `rebase -i` | Safe — descendants rebase automatically |

## The Operation Log vs Git Reflog

| Git Reflog | JJ Operation Log |
|------------|------------------|
| Tracks HEAD movements only | Tracks every repository change |
| Separate reflog per branch | One unified history |
| Entries expire (90 days) | Permanent history |
| Hard to understand | Clear command history |
| Can't restore complex states | Full state restoration |

See the [Operation Log guide](/guides/operation-log/) for the full reference.

## Revsets for Querying History

JJ has a powerful query language called "revsets" for selecting commits:

```bash
jj log -r "trunk..@"      # Commits between trunk and here
jj log -r "mine()"        # Your commits
jj log -r "stack"         # Current stack (LazyJJ alias)
jj rebase -s "stack" -d trunk   # Rebase entire stack
```

## Common Git User Confusions

**"Where's git stash?"**
→ Not needed. Your current commit already has your work. Just `jj edit <other-commit>` to switch contexts. Return with `jj edit <original>` and your work is still there.

**"How do I stage files?"**
→ You don't. Working copy is the commit. Files are automatically included. To split changes later, use `jj split`.

**"Why didn't my bookmark move?"**
→ JJ bookmarks don't auto-follow like Git branches. You must manually `jj bookmark set <name>`. See [Common Mistakes](/guides/common-mistakes/#mistake-2-expecting-bookmarks-to-auto-follow) for details.

**"How do I amend a commit?"**
→ Just edit files. Your working copy always amends the current commit. To edit an older commit, use `jj edit <change-id>`.

## Next Steps

- [Mental Model](/guides/mental-model/) — Full explanation of JJ's conceptual shifts
- [Quick Start](/quickstart/) — Get productive in 5 minutes
- [Common Mistakes](/guides/common-mistakes/) — Avoid the common pitfalls
