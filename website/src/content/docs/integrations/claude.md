---
title: Claude Integration
description: AI-assisted development with Claude CLI
---

LazyJJ integrates with [Claude CLI](https://github.com/anthropics/claude-code) for AI-assisted development workflows.

## Prerequisites

Install Claude CLI:

```bash
npm install -g @anthropic-ai/claude-code
```

Optional but recommended:
- **tmux** - For workspace management

## Commands

| Alias | Purpose |
|-------|---------|
| `clstart` | Create JJ workspace + tmux session |
| `clstop` | Stop and clean up workspace |
| `clresolve` | Resolve conflicts using Claude |
| `clreview` | Review a PR using Claude |
| `claude-checkpoint` | Save checkpoint with message |

## Workspace Management

Claude workspaces let you have Claude work on your code in an isolated JJ workspace:

```bash
# Start a Claude workspace
jj clstart my-feature

# Output:
# Started tmux session: my-feature
# Attach with: tmux attach -t my-feature
```

This creates:
1. A JJ workspace at `.jj-workspaces/my-feature`
2. A tmux session running Claude

When done:

```bash
# Stop and clean up
jj clstop my-feature
```

## Conflict Resolution

When you have merge conflicts, Claude can help:

```bash
# After a rebase with conflicts
jj clresolve
```

This runs Claude on each conflicted file to help resolve it.

## PR Review

Have Claude review a pull request:

```bash
# Review current PR
jj clreview

# Review specific PR
jj clreview 123
```

## Checkpointing

Create checkpoints while working:

```bash
# Save your progress with a message
jj claude-checkpoint "got auth working"
```

This describes the current commit and creates a new one.

## Workflow Example

A typical AI-assisted development session:

```bash
# Start fresh from trunk
jj start

# Start a Claude workspace for your feature
jj clstart auth-feature

# Attach to Claude session
tmux attach -t auth-feature

# ... Claude helps you implement the feature ...

# Checkpoint your work periodically
jj claude-checkpoint "basic auth flow done"

# When done, stop the workspace
jj clstop auth-feature

# Review and clean up your commits
jj stack
jj squash  # if needed

# Create PR
jj sprs
```

## Tips

### Multiple Claude Sessions

You can have multiple Claude workspaces:

```bash
jj clstart feature-a
jj clstart feature-b

# List workspaces
jj workspace list

# Attach to specific session
tmux attach -t feature-a
```

### Without tmux

If you don't have tmux, `clstart` still creates the workspace:

```bash
jj clstart my-feature
# Workspace created at: .jj-workspaces/my-feature
# tmux not available - start Claude manually in that directory

cd .jj-workspaces/my-feature
claude
```

### Cleaning Up Old Workspaces

```bash
# List all workspaces
jj workspace list

# Forget a workspace
jj workspace forget workspace-name

# Remove the directory
rm -rf .jj-workspaces/workspace-name
```
