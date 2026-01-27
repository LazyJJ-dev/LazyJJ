---
title: Introduction
description: What is LazyJJ and why should you use it
---

LazyJJ makes Jujutsu accessible—the version control system that finally makes stacked workflows feel natural.

## Why JJ?

Most version control frustrations stem from Git's architecture—designed for Linux kernel development in 2005. Jujutsu (JJ) is a modern replacement built for today's workflows:

- **Native stacking** — Commits have stable change IDs. Editing any commit automatically rebases descendants. No metadata layers, no fragility.
- **Safe experimentation** — The [operation log](/guides/operation-log/) records every action. `jj undo` reverses any operation. `jj op restore` time-travels to any state.
- **No staging area** — Your working directory **is** the commit. Edit files, they're in the commit. No `git add`.
- **First-class conflicts** — Conflicts are data, not errors. Commit on top of them, resolve when convenient, and the resolution propagates automatically.

See the [Mental Model guide](/guides/mental-model/) for the full explanation, or [Git vs JJ](/guides/git-differences/) for a detailed comparison.

## Why LazyJJ?

JJ is powerful but requires configuration to unlock its full potential. LazyJJ is a ready-to-use distribution—think **"LazyVim for JJ"**—that provides:

- **Sensible defaults** — Colors, pager settings, and UI tweaks
- **Core aliases** — Essential shortcuts for common operations
- **Stack workflow** — Commands for working with commit stacks
- **GitHub integration** — Create and manage stacked PRs with `gh` CLI
- **Claude integration** — AI-assisted development workflows

### Philosophy

1. **Opinionated but not restrictive** — Good defaults, but you can override anything
2. **Modular design** — Configuration split into logical, customizable files
3. **Stack-based workflow** — Optimized for working with commit stacks
4. **Modern tooling** — Integrates with GitHub CLI and Claude

## What's a Stack?

A "stack" is a series of commits from where you diverged from trunk to your current position. LazyJJ provides commands to view (`jj stack-view`), navigate (`jj stack-top`), sync (`jj stack-sync`), and push (`jj pr-stack-create`) your stack.

Unlike Git or Graphite, stacks are native to JJ's model—edit any commit and descendants rebase automatically. No manual restacking, no metadata to break. See [Stack Workflow](/reference/stack/) for all commands.

## Getting Started

Ready to try LazyJJ? Head to the [Installation](/installation/) guide.

Already installed? Start with the [Quick Start](/quickstart/)—get productive in 5 minutes.
