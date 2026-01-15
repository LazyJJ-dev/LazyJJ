---
title: Introduction
description: What is LazyJJ and why should you use it
---

LazyJJ is a ready-to-use distribution for [Jujutsu (JJ)](https://jj-vcs.github.io/jj/), the modern version control system. Think of it as "LazyVim for JJ" - it provides sensible defaults, powerful aliases, and modern workflows out of the box.

## Why LazyJJ?

Jujutsu is powerful but requires configuration to unlock its full potential. LazyJJ provides:

- **Sensible defaults** - Colors, pager settings, and UI tweaks
- **Core aliases** - Essential shortcuts everyone needs
- **Stack workflow** - Commands for working with commit stacks
- **GitHub integration** - Create and manage stacked PRs
- **Claude integration** - AI-assisted development workflows

## Philosophy

LazyJJ follows these principles:

1. **Opinionated but not restrictive** - We provide good defaults, but you can override anything
2. **Modular design** - Configuration is split into logical files
3. **Stack-based workflow** - Optimized for working with commit stacks
4. **Modern tooling** - Integrates with GitHub CLI and Claude

## What's a Stack?

A "stack" in JJ is a series of commits from where you diverged from trunk to your current position. LazyJJ provides commands to:

- View your current stack (`jj stack`)
- Navigate within your stack (`jj top`, `jj bottom`)
- Sync your stack with trunk (`jj sync`)
- Create stacked PRs (`jj sprs`)

## Getting Started

Ready to try LazyJJ? Head to the [Installation](/installation/) guide.
