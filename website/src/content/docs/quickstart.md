---
title: Quick Start
description: Get productive with LazyJJ in 5 minutes, comfortable in 4-8 hours
---

This guide will get you productive with LazyJJ in 5 minutes. Mastering the mental model takes 4-8 hours, but it's worth it—JJ makes version control finally make sense.

## Understanding JJ's Model (Read This First!)

Before diving into commands, understand the key difference:

### In Git:
```
Edit files → git add → git commit
(staging area prepares for future commit)
```

### In JJ:
```
Edit files → (changes automatically in commit)
jj new → (start next commit)
```

**Your working copy IS a commit**, not a staging area preparing for one. When you edit files, you're editing the commit directly. No `git add` needed—everything is automatic.

This feels strange for the first few hours. Then it clicks, and you'll wonder how you tolerated Git's complexity. Give it time.

Want deeper explanation? Read the [Mental Model guide](/guides/mental-model/) after finishing this quickstart.

---

## Your First Commands

After [installing LazyJJ](/installation/), try these commands in any JJ repository:

```bash
# Check status (shortcut: jj st)
jj status

# View recent history (shortcut: jj l)
jj log-short

# View changes (shortcut: jj d)
jj diff
```

---

## Creating Commits

```bash
# Create a new commit
jj new -m "Add awesome feature"

# Edit your changes
vim src/feature.js

# View them
jj diff
# ✨ Notice: No `git add` needed!
# Your changes are automatically part of the commit

# Describe your commit (you can do this multiple times)
jj describe -m "Add awesome feature

- Implement core logic
- Add error handling"

# Create next commit
jj new -m "Add tests"
```

**Key insight**: `jj new` seals the current commit and starts a fresh one. Think of it as "finalize and move to next."

---

## Basic Revsets You'll Use Daily

Revsets are JJ's query language for selecting commits. You'll use these constantly:

| Revset | Meaning | Example Use |
|--------|---------|-------------|
| `@` | Current commit (where you are now) | `jj diff -r @` |
| `@-` | Parent of current commit | `jj new @-` (new commit from parent) |
| `@+` | Child of current commit (if only one) | `jj edit @+` |
| `main..@` | Commits between main and current | `jj log -r "main..@"` |
| `stack` | Your current stack (LazyJJ alias) | `jj log -r stack` |

Examples:

```bash
# See commits in your current stack
jj log -r stack

# Diff against main
jj diff -r "main..@"

# Create new commit from parent
jj new @-

# See what's in current commit
jj diff -r @
```

Need more complex queries? See [Advanced Revsets](/reference/revsets-advanced/).

---

## Working with Stacks

A "stack" is the series of commits from trunk to your current position:

```bash
# View your current stack
jj stack-view

# Navigate to the top of your stack
jj stack-top

# Navigate to the bottom
jj stack-bottom

# Sync your stack with the latest trunk
jj stack-sync
```

---

## Starting Fresh

```bash
# Fetch latest and start from trunk
jj stack-start
```

---

## Viewing All Your Work

```bash
# View all your stacks (all mutable commits you own)
jj stacks-all
```

---

## GitHub Workflow

If you have GitHub CLI (`gh`) installed:

```bash
# View current PR
jj pr-view

# Open PR in browser
jj pr-open

# Create/update stacked PRs
jj pr-stack-create
```

---

## Experimentation is Safe

Made a mistake? Undo it:

```bash
jj undo
```

Everything in JJ is recorded in the **operation log**. You can undo any operation. This makes JJ one of the safest version control systems ever created.

```bash
# See your operation history
jj op log

# Restore to any previous state
jj op restore <operation-id>
```

Learn more: [Operation Log guide](/guides/operation-log/)

---

## Common Beginner Mistakes

Avoid these pitfalls during your first few hours:

1. **Don't use `git` commands** - Use `jj` equivalents. Git doesn't understand JJ's operation log. [Details](/guides/common-mistakes/#mistake-1-using-git-commands-on-jj-managed-code)

2. **Bookmarks don't auto-follow** - Unlike Git branches, you must manually move bookmarks with `jj bookmark set`. [Details](/guides/common-mistakes/#mistake-2-expecting-bookmarks-to-auto-follow)

3. **Use `jj new` to finalize commits** - `jj describe` just sets the message. Use `jj new` to start the next commit. [Details](/guides/common-mistakes/#mistake-5-forgetting-jj-new-after-describing-a-commit)

4. **Trust `jj undo`** - Experiment freely. The operation log makes everything reversible. [Details](/guides/common-mistakes/#mistake-6-not-trusting-the-operation-log)

Full list: [Common Mistakes guide](/guides/common-mistakes/)

---

## The Learning Curve (It's Worth It)

Research across 20+ guides shows a consistent pattern:

- **Minutes 1-30**: Confusion ("Where's `git add`?")
- **Hours 1-4**: Awkwardness (muscle memory fights you)
- **Hours 4-8**: The "click" (suddenly it makes sense)
- **After 8 hours**: "I'll never go back to Git"

One developer: "I became comfortable enough with jj to replace git entirely in **one day**."

Don't fight the model. Let it feel strange for a few hours. Your Git habits will adapt.

---

## Next Steps

### Essential Reading (10 minutes)
- [Mental Model](/guides/mental-model/) - Understand why JJ works this way
- [Operation Log](/guides/operation-log/) - Your safety net explained
- [Common Mistakes](/guides/common-mistakes/) - Avoid frustration

### Learn the Workflow (30 minutes)
- [Create a Stack](/tutorials/create-stack/) - Build stacked PRs
- [Navigate Stacks](/tutorials/navigate-stack/) - Move between commits
- [Edit Mid-Stack](/tutorials/edit-mid-stack/) - JJ's killer feature

### Reference Material
- [All Aliases](/reference/aliases/) - Command shortcuts
- [Stack Commands](/reference/stack/) - Complete stack workflow
- [Advanced Revsets](/reference/revsets-advanced/) - Complex queries

### Integrations
- [GitHub Integration](/integrations/github/) - Stacked PRs
- [Claude Integration](/integrations/claude/) - AI-assisted development

Give yourself 4-8 hours with JJ. The "aha moment" is real, and it's worth the initial learning curve.
