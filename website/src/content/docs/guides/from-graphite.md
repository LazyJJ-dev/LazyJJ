---
title: LazyJJ vs Graphite
description: Why LazyJJ is a better choice for stacked workflows, plus a migration guide
---

Both LazyJJ and [Graphite](https://graphite.dev) provide stacked PR workflows, but they take fundamentally different approaches. JJ offers **native stacking** built into the version control system itself—not bolted onto Git.

## What JJ Does Better

| What You Loved in Graphite | How JJ Does It Better |
|----------------------------|----------------------|
| `gt modify -a` amends current commit | Every file edit **automatically** amends—no command needed |
| `gt stack restack` rebases dependencies | Automatic—descendants rebase when you edit any commit |
| `gt ls` visualization | `jj log`—same concept, native to the tool, faster |
| Git passthrough for git commands | Full Git compatibility—`jj git push`, `jj git fetch` |
| Branches treated as commits | True commits with stable **change IDs**, branches optional |
| Undo... (missing in Graphite!) | `jj undo`—undo **ANY** operation |
| Stack workflow | Native to JJ's architecture, not bolted on |

### Open Source & No Service Dependency

**JJ is fully open source** (Apache 2.0). LazyJJ works with any Git remote—GitHub, GitLab, Bitbucket, self-hosted. No cloud service required.

Graphite's CLI is source-available but their core service is proprietary. Features like merge queues, dashboards, and PR stack status require their cloud.

### More Powerful Foundation

JJ provides capabilities Graphite simply can't offer:

- **First-class conflicts** — Conflicts don't block your workflow. Keep working, resolve later. See [Working with Conflicts](/tutorials/resolve-conflicts/).
- **Full undo** — Every operation is recorded and reversible via `jj undo` and `jj op restore`. See [Operation Log](/guides/operation-log/).
- **Revsets** — A query language for selecting commits: `jj log -r "mine() & mutable()"`.
- **Anonymous branches** — No branch names required. Work freely, create bookmarks only when pushing PRs.
- **Offline support** — All operations are local. No network calls.

## Feature Comparison

| Feature | LazyJJ/JJ | Graphite |
|---------|-----------|----------|
| Open source | Yes (Apache 2.0) | CLI source-available |
| Service dependency | None | Required for some features |
| Git hosting | Any | GitHub only |
| Conflict handling | First-class | Git's model |
| Undo support | Full operation log | Limited |
| Query language | Revsets | None |
| Offline support | Full | Partial |
| Customization | Full | Limited |
| Stacking model | Native to VCS | Wrapper on Git |

## Graphite Pain Points You Won't Miss

1. **Signed Commits Break** — Organization-mandated GPG signing fails when Graphite rebases internally. No workaround.

2. **Collaboration Friction** — If one developer restacks, collaborators on dependent branches are stuck. Graphite works best solo.

3. **Metadata Fragility** — Use any git command directly (`git rebase`, `git merge`) and Graphite's metadata breaks.

4. **Third-Party Dependency** — Your workflow depends on Graphite's infrastructure for API auth and PR management.

5. **The Fundamental Mismatch** — Graphite fights Git's branch model. JJ embraces a change-based model from the ground up.

## The Mental Model Upgrade

### Graphite's Approach
- Treats branches as commits (but they're still Git branches underneath)
- Forces "one commit per branch" discipline
- Metadata tracks relationships between branches

### JJ's Approach
- Commits have stable **change IDs** that survive rewrites
- Branches (bookmarks) are optional labels
- Relationships live in the commit graph—no metadata needed

This isn't just a nicer CLI—it's a fundamentally better architecture. See the [Mental Model guide](/guides/mental-model/) for the full explanation.

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

**Note**: JJ doesn't have direct "up/down one commit" commands. Use `jj edit <change-id>` to jump to any commit, or `jj stack-top` to go to the top.

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

## When to Use Graphite

Graphite might still be a good choice if you:
- Need their merge queue feature
- Want their web dashboard and analytics
- Prefer their specific PR workflow
- Are invested in their ecosystem

## The Transition

### What Transfers Directly

- **Stack thinking** — You already understand stacked PRs
- **Visualization** — `jj log` is like `gt ls`, just better
- **Breaking work into small PRs** — Same workflow
- **Rebasing discipline** — You're comfortable with history manipulation

### What's Different

- **No staging** — Edit files, they're in the commit. Period.
- **Automatic amend** — No `gt modify -a` needed
- **Bookmarks** — Optional, only for pushing to GitHub
- **Operation log** — Trust `jj undo` and experiment freely

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

- Read the [Mental Model guide](/guides/mental-model/) — Understand JJ's approach
- Try the [Quick Start](/quickstart/) — Get productive in 5 minutes
- Learn [Common Mistakes](/guides/common-mistakes/) — Avoid frustration
- Explore the [Operation Log](/guides/operation-log/) — Your safety net
