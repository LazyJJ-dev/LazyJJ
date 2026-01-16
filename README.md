<p align="center">
  <img src="website/src/assets/logo-light.svg" alt="LazyJJ Logo" width="200"/>
</p>

<h1 align="center">LazyJJ</h1>

<p align="center">
  <strong>Ready-to-use Jujutsu configuration for stacked PR workflows</strong>
</p>

<p align="center">
  Stack commands • Claude Code integration • GitHub helpers • Sensible defaults
</p>

---

## What is LazyJJ?

LazyJJ is a pre-configured [Jujutsu (JJ)](https://jj-vcs.github.io/jj/) distribution that gives you a complete stacked workflow out of the box.

Vanilla JJ is powerful but requires configuration. LazyJJ provides:

- **Stack workflow commands** - Navigate and manage stacks of commits for stacked PRs
- **Claude Code integration** - Streamlined worktree management for AI pair programming
- **GitHub helpers** - Create and manage stacked PRs with `gh` CLI
- **Sensible defaults** - Colors, aliases, and UI tweaks pre-configured

All built on JJ's native capabilities: no staging area, operation log with undo, first-class conflicts, and automatic rebasing.

## Why JJ?

Jujutsu is a modern version control system that makes stacking natural:

- **Native stacking** - Built into the VCS, not bolted on
- **First-class conflicts** - Don't block your workflow
- **Automatic rebasing** - Edit any commit, descendants rebase automatically

## Installation

```bash
curl -fsSL https://lazyjj.dev/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/lazyjj-dev/lazyjj.git ~/.config/jj/lazyjj
cd ~/.config/jj/lazyjj && ./install.sh
```

## Quick Start

After installation:

```bash
# Initialize JJ in your Git repo
jj git init --colocate

# Start a new feature from trunk
jj stack-start

# Make changes (automatically in the commit!)
vim src/feature.js

# Describe your work
jj describe -m "Add feature"

# Create next commit
jj new

# View your stack
jj stack-view

# Create stacked PRs
jj pr-stack-create
```

See the [Quick Start guide](https://lazyjj.dev/quickstart/) for more.

## What You Get

### 📚 Stack Workflow Commands

Navigate and manage stacks of commits for stacked PRs:

| Command        | Shortcut | Purpose                       |
| -------------- | -------- | ----------------------------- |
| `stack-view`   | `stack`  | View current stack with trunk |
| `stacks-all`   | `stacks` | View all your stacks          |
| `stack-top`    | `top`    | Jump to top of stack          |
| `stack-bottom` | `bottom` | Jump to bottom of stack       |
| `stack-sync`   | `sync`   | Fetch and rebase onto trunk   |
| `stack-start`  | `start`  | Fresh start from trunk        |

### 🤖 Claude Code Integration

Streamlined worktree management for AI pair programming:

| Command             | Shortcut    | Purpose                            |
| ------------------- | ----------- | ---------------------------------- |
| `claude-start`      | `clstart`   | Create JJ workspace + tmux session |
| `claude-stop`       | `clstop`    | Stop and clean up workspace        |
| `claude-resolve`    | `clresolve` | AI-assisted conflict resolution    |
| `claude-review`     | `clreview`  | AI-assisted PR review              |
| `claude-checkpoint` | -           | Save progress checkpoint           |

### 🔗 GitHub Integration

Create and manage stacked PRs (requires `gh` CLI):

| Command            | Shortcut | Purpose                   |
| ------------------ | -------- | ------------------------- |
| `pr-view`          | `prv`    | View current PR           |
| `pr-open`          | `pro`    | Open PR in browser        |
| `pr-stack-create`  | `sprs`   | Create/update stacked PRs |
| `pr-stack-summary` | `prs`    | Generate PR stack summary |

### ⚡ Core Aliases

Essential shortcuts and value-add commands:

| Alias   | Command                     | Purpose              |
| ------- | --------------------------- | -------------------- |
| `st`    | `status`                    | Quick status         |
| `d`     | `diff`                      | View changes         |
| `l`     | `log --limit 10`            | Quick log            |
| `n`     | `new`                       | New commit           |
| `e`     | `edit`                      | Edit commit          |
| `diffs` | `diff --summary --no-pager` | Compact diff summary |
| `gf`    | `git fetch`                 | Fetch from remote    |

## Configuration

LazyJJ installs to `~/.config/jj/lazyjj/` and symlinks config files to `~/.config/jj/conf.d/`.

JJ loads all `.toml` files from `conf.d/` in lexicographic order, so your personal overrides in `~/.config/jj/conf.d/zzz-*.toml` will take precedence.

Your personal config (name, email) stays in `~/.config/jj/config.toml`.

## Learn More

- 📖 [Full Documentation](https://lazyjj.dev/)
- 🚀 [Quick Start Guide](https://lazyjj.dev/quickstart/)
- 📚 [Stack Workflow](https://lazyjj.dev/reference/stack/)
- 🔗 [GitHub Integration](https://lazyjj.dev/integrations/github/)
- 🤖 [Claude Integration](https://lazyjj.dev/integrations/claude/)

## Uninstall

```bash
~/.config/jj/lazyjj/install.sh --uninstall
```

## License

MIT
