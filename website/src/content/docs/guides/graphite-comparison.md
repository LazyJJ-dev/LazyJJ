---
title: LazyJJ vs Graphite
description: Why choose LazyJJ over Graphite for stacked workflows
---

Both LazyJJ and [Graphite](https://graphite.dev) provide stacked PR workflows, but they take fundamentally different approaches. Here's why LazyJJ (powered by Jujutsu) might be a better choice.

## Open Source

**Jujutsu is fully open source** (Apache 2.0 license), developed by Google and a growing community. You can inspect the code, contribute, and trust that it will remain free.

Graphite's CLI is source-available but their core service is proprietary. Your workflow depends on their business decisions.

## Native Stacking vs Wrapper

**JJ has first-class support for stacking built into the version control system itself.** Stacks aren't a feature bolted on top - they're how JJ naturally works.

Graphite is a wrapper around Git. It maintains parallel metadata to track stacks, which can get out of sync with Git's state. JJ's approach is fundamentally more reliable.

## No Service Dependency

**LazyJJ works with any Git remote** - GitHub, GitLab, Bitbucket, self-hosted. Your workflow isn't tied to any service.

Graphite requires their cloud service for features like:
- Viewing PR stack status
- Merge queues
- Dashboard analytics

With LazyJJ, all stack management happens locally. Use any Git hosting you want.

## More Powerful Foundation

JJ provides capabilities that Graphite simply can't offer:

### First-Class Conflict Handling

In Graphite/Git, conflicts block your workflow. In JJ, conflicts are just another state:

```bash
# JJ lets you continue working with conflicts
jj new              # Create new commit even with conflicts below
jj status           # See which commits have conflicts
jj resolve          # Resolve when you're ready
```

### Undo Any Operation

Every JJ operation is recorded and reversible:

```bash
jj undo             # Undo last operation
jj op log           # See full operation history
jj op restore <id>  # Go back to any point
```

Graphite has `gt undo` but it's limited compared to JJ's comprehensive operation log.

### Revsets for Powerful Queries

JJ's revset language lets you query and operate on commits:

```bash
jj log -r "mine() & mutable()"     # All your work in progress
jj log -r "trunk..@ & conflicts()" # Conflicted commits in your stack
jj abandon "empty()"               # Remove all empty commits
```

Graphite has no equivalent.

### Anonymous Branches

JJ doesn't require branch names. You can work freely and only create bookmarks when needed for PRs:

```bash
jj new                              # Just start working
jj describe -m "Add feature"
# ... later, when ready to push ...
jj bookmark-create feature-name
```

Graphite requires a branch for every commit in your stack.

## Works Offline

**LazyJJ works completely offline.** All operations happen locally with no network calls.

Graphite's CLI phones home for analytics and some features require their service to be available.

## Fully Customizable

JJ's configuration is transparent TOML files. LazyJJ is a collection of aliases and settings you can modify:

```bash
# See exactly what any command does
cat ~/.config/jj/lazyjj/config/lazyjj-stack.toml

# Override anything in your own config
# ~/.config/jj/conf.d/zzz-my-overrides.toml
```

Graphite's behavior is largely fixed.

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

## When to Use Graphite

Graphite might still be a good choice if you:
- Need their merge queue feature
- Want their web dashboard and analytics
- Prefer their specific PR workflow
- Are invested in their ecosystem

## When to Use LazyJJ

LazyJJ is better if you:
- Want truly open source tools
- Need to work with non-GitHub remotes
- Want more powerful version control features
- Prefer local-first, offline-capable tools
- Want full control over your workflow
- Care about data sovereignty

## Ready to Switch?

If you're coming from Graphite, check out the [From Graphite to LazyJJ](/guides/from-graphite/) guide for a command-by-command mapping and migration help.
