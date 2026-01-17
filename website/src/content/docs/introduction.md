---
title: Introduction
description: What is LazyJJ and why should you use it
---

LazyJJ makes Jujutsu accessible—the version control system that finally makes stacked workflows feel natural.

## Why JJ?

Most version control frustrations stem from Git's architecture. Git was designed for Linux kernel development in 2005, with a staging area, detached HEAD states, and a branch model that fights modern workflows.

Jujutsu (JJ) is a modern version control system built from the ground up with today's workflows in mind:

### Native Stacking

Git's branch model was never designed for stacked PRs. Tools like Graphite try to bolt stacking onto Git, but they fight the underlying architecture—leading to metadata fragility, signed commit issues, and collaboration friction.

JJ's change-based model makes stacking natural. Commits have stable change IDs that survive rewrites. Editing any commit automatically rebases descendants. This isn't a layer on top—it's how JJ works.

### Safe Experimentation

Git's destructive operations (`git reset --hard`, `git rebase -i`) require careful planning. One wrong move and you're searching StackOverflow for recovery commands.

JJ's operation log records every action you take—every rebase, every conflict resolution, everything. `jj undo` reverses any operation. `jj op restore` lets you time-travel to any previous state. Experimentation becomes safe.

### No Staging Area Mental Overhead

Git's staging area (the "index") is a persistent state between working directory and commits. You explicitly add/remove files, track what's staged vs unstaged, and manage transitions between states.

JJ eliminates the staging area entirely. Your working directory **is** the commit. Edit files, they're in the commit. No `git add`, no mental overhead about "unstaged changes."

### First-Class Conflicts

Git treats conflicts as errors that halt operations until resolved. You must stop what you're doing and fix conflicts immediately.

JJ treats conflicts as data you can commit, work around, and resolve whenever convenient. Create new work on top of conflicted commits. Resolve once, and the resolution propagates through your stack automatically.

## Why LazyJJ?

Jujutsu is powerful but requires configuration to unlock its full potential. LazyJJ is a ready-to-use distribution—think "LazyVim for JJ"—that provides:

- **Sensible defaults** - Colors, pager settings, and UI tweaks
- **Core aliases** - Essential shortcuts for common operations (`jj gf`, `jj diffs`, `jj stack`)
- **Stack workflow** - Commands for working with commit stacks
- **GitHub integration** - Create and manage stacked PRs with `gh` CLI
- **Claude integration** - AI-assisted development workflows

## Philosophy

LazyJJ follows these principles:

1. **Opinionated but not restrictive** - We provide good defaults, but you can override anything
2. **Modular design** - Configuration is split into logical files you can customize
3. **Stack-based workflow** - Optimized for working with commit stacks
4. **Modern tooling** - Integrates with GitHub CLI and Claude

## What's a Stack?

A "stack" in JJ is a series of commits from where you diverged from trunk to your current position. LazyJJ provides commands to:

- View your current stack (`jj stack-view`)
- Navigate within your stack (`jj stack-top`, `jj edit <change-id>`)
- Sync your stack with trunk (`jj stack-sync`)
- Create stacked PRs (`jj pr-stack-create`)

Unlike Git or Graphite, stacks are native to JJ's model:
- **Git**: Branches fight the stacking workflow. Rebasing is manual and error-prone.
- **Graphite**: Stacks are metadata layered on Git. Break the discipline, break the stack.
- **JJ**: Stacks are the natural structure of the commit graph. Edit any commit, descendants rebase automatically.

Graphite's "stack" is actually a queue fighting Git's branch model. JJ's stack is a genuine tree structure built into the version control system.

## Comparison to Alternatives

### vs Git

**Problems**: Staging area confusion, dangerous operations (`reset --hard`), rebasing requires deep understanding, detached HEAD states, conflicts block workflow.

**JJ's Solution**: No staging area, operation log makes everything safe, automatic descendant rebasing, conflicts are first-class data.

### vs Graphite

**Problems**: Third-party service dependency, metadata fragility when using git commands, signed commits break, collaboration friction ("if one dev restacks, others are hosed"), branches-vs-patches impedance mismatch.

**JJ's Solution**: Client-side tool (no service dependency), operation log is the metadata (no fragility), native change-based model (no impedance mismatch), local operation log (no collaboration conflicts).

### vs Vanilla JJ

**Problems**: Configuration overhead, no sensible defaults, missing integrations, steep learning curve to set up.

**LazyJJ's Solution**: Pre-configured with community best practices, GitHub and Claude integrations included, stack workflow aliases ready to use, modular configuration you can customize.

## The Catch

JJ has a learning curve. Your Git muscle memory will fight you for the first 4-8 hours. Commands feel different. Bookmarks don't auto-follow. The mental model shift takes time.

But research across 20+ community guides shows consistent results:
- Hours 1-4: Awkward ("This feels wrong")
- Hours 4-8: The "click" ("Oh, NOW I get it")
- After 8 hours: Converts ("I'll never go back to Git")

One developer: "I became comfortable enough with jj to replace git entirely in **one day**."

The investment is worth it. JJ makes version control finally make sense.

## Getting Started

Ready to try LazyJJ? Head to the [Installation](/installation/) guide.

Already installed? Start with the [Quick Start](/quickstart/) guide—get productive in 5 minutes, comfortable in 4-8 hours.

## Learn More

- [Mental Model](/guides/mental-model/) - Understand JJ's fundamental differences
- [From Graphite](/guides/from-graphite/) - If you're escaping Graphite's limitations
- [Git vs JJ](/guides/git-differences/) - Detailed comparison for Git users
- [Operation Log](/guides/operation-log/) - Your safety net explained

Welcome to the future of version control.
