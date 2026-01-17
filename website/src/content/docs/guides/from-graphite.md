---
title: From Graphite to LazyJJ
description: Escaping Graphite's limitations - why JJ does stacking better
---

If you're here, you've likely hit one of Graphite's frustrations: signed commits breaking, collaboration friction, metadata fragility, or the fundamental "branches-vs-patches impedance mismatch" that can never be fully resolved.

JJ offers what Graphite promised but couldn't deliver: **native stacking** built into the version control system itself, not bolted onto Git.

## Why You're Here: The Graphite Reality

Graphite is a valiant attempt to add stacking to GitHub. But research shows consistent pain points:

### The Problems You Won't Miss

1. **Signed Commits Break** - Organization-mandated GPG signing fails when Graphite rebases internally. No workaround.

2. **Collaboration Friction** - If one developer restacks, collaborators on dependent branches are "hosed." Graphite works best when only one person touches a stack.

3. **Metadata Fragility** - If you use any git command directly (`git rebase`, `git merge`), Graphite's metadata breaks. You must stay within Graphite's commands.

4. **Third-Party Dependency** - Graphite requires an external service for API authentication and PR management. Your workflow depends on their infrastructure.

5. **The Fundamental Mismatch** - As one developer notes: "That mismatch [branches vs. patches] cannot be fully resolved and results in constant friction."

Graphite fights Git's branch model. JJ embraces a change-based model from the ground up.

## What JJ Does Better Than Graphite

| What You Loved in Graphite | How JJ Does It Better |
|----------------------------|----------------------|
| `gt modify -a` amends current commit | Every file edit **automatically** amends - no command needed |
| `gt stack restack` rebases dependencies | Automatic - descendants rebase when you edit any commit |
| `gt ls` visualization | `jj log` - same concept, native to the tool, faster |
| Git passthrough for git commands | Full Git compatibility - `jj git push`, `jj git fetch` |
| Branches treated as commits | True commits with stable **change IDs**, branches optional |
| Undo... (missing in Graphite!) | `jj undo` - undo **ANY** operation |
| Stack workflow | Native to jj's architecture, not bolted on |

## The Mental Model Upgrade

### Graphite's Approach
- Treats branches as commits (but they're still Git branches underneath)
- Forces "one commit per branch" discipline
- Metadata tracks relationships between branches
- Git's branch model fights you constantly

### JJ's Approach
- Commits have stable **change IDs** that survive rewrites
- Branches (bookmarks) are optional labels
- No metadata needed—relationships are in the commit graph
- The model is designed for stacking from the ground up

This isn't just a nicer CLI—it's a fundamentally better architecture.

## Command Cheatsheet

### Viewing Your Stack

| Graphite | LazyJJ | Notes |
|----------|--------|-------|
| `gt log` | `jj stack-view` | View current stack |
| `gt log short` / `gt ls` | `jj stacks-all` | View all your stacks |
| `gt branch` | `jj log -r @` | Show current commit |

### Creating and Modifying

| Graphite | LazyJJ | Notes |
|----------|--------|-------|
| `gt create -m "msg"` | `jj describe -m "msg" && jj new` | Create named commit |
| `gt create -am "msg"` | `jj describe -m "msg" && jj new` | Stage all + create |
| `gt modify` | (automatic) | Amend current commit |
| `gt modify -a` | (automatic) | Stage all + amend |
| `gt modify -c` | `jj new && jj describe` | Add new commit to branch |

**Key difference**: In JJ, your working copy automatically amends the current commit. No explicit "modify" step needed—just edit files.

### Syncing and Submitting

| Graphite | LazyJJ | Notes |
|----------|--------|-------|
| `gt sync` | `jj stack-sync` | Fetch + rebase onto trunk |
| `gt submit` | `jj stack-submit` | Push current stack |
| `gt submit --stack` / `gt ss` | `jj stack-submit` | Push entire stack |

### Navigating

| Graphite | LazyJJ | Notes |
|----------|--------|-------|
| `gt checkout` / `gt co` | `jj edit` | Switch to commit |
| `gt up` / `gt u` | `jj edit <change-id>` | Move up one |
| `gt down` / `gt d` | `jj edit <change-id>` | Move down one |
| `gt top` / `gt t` | `jj stack-top` | Go to top of stack |

**Note**: JJ doesn't have direct "up/down one commit" commands because its commit model is different. Use `jj edit <change-id>` to jump to any commit, or `jj stack-top` to go to the top of the stack.

### Reorganizing

| Graphite | LazyJJ | Notes |
|----------|--------|-------|
| `gt fold` | `jj squash` | Squash into parent |
| `gt squash` | `jj squash --keep-emptied` | Squash commits in branch |
| `gt split` | `jj split` | Split commit into multiple |
| `gt reorder` | `jj rebase` | Reorder commits |
| `gt move` | `jj rebase -r X -d Y` | Move commit to new parent |

### Recovery

| Graphite | LazyJJ | Notes |
|----------|--------|-------|
| `gt undo` | `jj undo` | Undo last operation |
| (none) | `jj op log` | View operation history |
| (none) | `jj op restore <id>` | Restore to any point |

**Graphite missing**: Comprehensive undo. JJ's operation log records every action—rebase, conflict resolution, anything.

## Key Workflow Differences

### 1. No Staging Area

```bash
# Graphite (like Git)
gt add file.txt
gt modify

# JJ - just edit files
vim file.txt
# Done! Changes are automatically in your commit
```

### 2. Change IDs vs Branch Names

```bash
# Graphite requires naming every branch
gt create my-feature

# JJ uses change IDs - branches optional
jj new -m "Add feature"
# Works with change ID: qpvuntsm
# Branch name (bookmark) only needed for GitHub PRs
```

### 3. Automatic Rebasing

```bash
# Graphite - must explicitly restack
gt modify -a
gt stack restack

# JJ - automatic
jj edit mid-stack-commit
vim file.txt
# Descendants automatically rebase!
```

No manual `gt restack` needed. Ever.

### 4. Conflicts Don't Block You

```bash
# Graphite (like Git) - conflict stops you
gt sync
# ❌ Resolve conflicts now or you're stuck

# JJ - conflicts are just data
jj stack-sync
# ✓ Conflict marked, but you can keep working
jj new -m "Other feature"
# Work on something else, resolve conflict later
```

See [Working with Conflicts](/tutorials/resolve-conflicts/) for details.

## Problems You Won't Miss

### No More "One Commit Per Branch" Discipline

Graphite requires discipline: one commit per branch, always amend. Break this and metadata breaks.

JJ has no such restriction. Commits can have any shape. Use `jj split` if you want to divide them, `jj squash` to combine. The operation log prevents mistakes.

### No More Metadata Breaking with Git Commands

In Graphite, using `git rebase` or `git merge` breaks stack tracking.

In JJ, the operation log is the metadata. Even if you use git commands (`jj git push`, etc.), JJ's state stays consistent. Though you should still prefer jj commands—see [Common Mistakes](/guides/common-mistakes/).

### No More Collaboration Friction

Graphite research shows: "If one dev restacks, collaborators on dependent branches are hosed."

JJ's operation log prevents this. Each developer's operations are local. When you fetch, JJ merges states gracefully. And if something breaks, `jj undo` fixes it.

### No More Third-Party Service Dependency

Graphite requires their API for PR management and authentication.

JJ is a client-side tool. LazyJJ integrates directly with GitHub CLI (`gh`). No external service required.

## The Transition

### What Transfers Directly

- **Stack thinking** - You already understand stacked PRs
- **Visualization** - `jj log` is like `gt ls`, just better
- **Breaking work into small PRs** - Same workflow
- **Rebasing discipline** - You're comfortable with history manipulation

### What's Different

- **No staging** - Edit files, they're in the commit. Period.
- **Automatic amend** - No `gt modify -a` needed
- **Bookmarks** - Optional, only for pushing to GitHub
- **Operation log** - Trust `jj undo` and experiment freely

Read the [Mental Model guide](/guides/mental-model/) to understand the shifts.

### Learning Curve

Research on jj transitions shows:
- **First hour**: Confusion (muscle memory fights you)
- **Hours 2-4**: Awkwardness (but starting to see benefits)
- **Hours 4-8**: The "click" (suddenly it makes sense)
- **After 8 hours**: "I'll never go back"

One developer: "I became comfortable enough with jj to replace git entirely in one day."

Graphite users have an advantage—you already understand stacking. You just need to unlearn Git's limitations.

## Real-World Example

### Graphite Workflow

```bash
gt sync
gt create -am "Database schema"
gt create -am "User model"
gt create -am "API endpoints"
gt submit --stack

# Reviewer requests changes to user model
gt checkout user-model
vim src/models/user.js
gt modify -a
gt submit

# Conflicts in API endpoints
gt checkout api-endpoints
# Resolve conflicts manually
gt submit
```

### JJ Equivalent

```bash
jj stack-sync
jj new -m "Database schema"
vim schema.sql
jj new -m "User model"
vim src/models/user.js
jj new -m "API endpoints"
vim src/api/users.js
jj pr-stack-create

# Reviewer requests changes to user model
jj edit <user-model-commit>
vim src/models/user.js
# Automatically amends!
# Automatically rebases API endpoints!
jj stack-submit

# Conflicts? They're just marked, not blocking
# Resolve when convenient
```

Notice what's missing:
- No `gt modify -a` (automatic)
- No `gt stack restack` (automatic)
- No manual conflict resolution in dependent commits (propagates automatically)

## Next Steps

- Read the [Mental Model guide](/guides/mental-model/) - Understand jj's approach
- Try the [Quick Start](/quickstart/) - Get productive in 5 minutes
- Learn [Common Mistakes](/guides/common-mistakes/) - Avoid frustration
- Explore the [Operation Log](/guides/operation-log/) - Your safety net

Welcome to version control that finally makes sense. You're going to love it.
