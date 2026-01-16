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

| Command | Shortcut | Purpose |
|---------|----------|---------|
| `claude-start` | `clstart` | Create JJ workspace + tmux session |
| `claude-stop` | `clstop` | Stop and clean up workspace |
| `claude-resolve` | `clresolve` | Resolve conflicts using Claude |
| `claude-review` | `clreview` | Review a PR using Claude |
| `claude-checkpoint` | - | Save checkpoint with message |

## Workspace Management

Claude workspaces let you have Claude work on your code in an isolated JJ workspace:

```bash
# Start a Claude workspace
jj claude-start my-feature

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
jj claude-stop my-feature
```

## Conflict Resolution

When you have merge conflicts, Claude can help:

```bash
# After a rebase with conflicts
jj claude-resolve
```

This runs Claude on each conflicted file to help resolve it.

## PR Review

Have Claude review a pull request:

```bash
# Review current PR
jj claude-review

# Review specific PR
jj claude-review 123
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
jj stack-start

# Start a Claude workspace for your feature
jj claude-start auth-feature

# Attach to Claude session
tmux attach -t auth-feature

# ... Claude helps you implement the feature ...

# Checkpoint your work periodically
jj claude-checkpoint "basic auth flow done"

# When done, stop the workspace
jj claude-stop auth-feature

# Review and clean up your commits
jj stack-view
jj squash  # if needed

# Create PR
jj pr-stack-create
```

## Tips

### Multiple Claude Sessions

You can have multiple Claude workspaces:

```bash
jj claude-start feature-a
jj claude-start feature-b

# List workspaces
jj workspace list

# Attach to specific session
tmux attach -t feature-a
```

### Without tmux

If you don't have tmux, `claude-start` still creates the workspace:

```bash
jj claude-start my-feature
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
