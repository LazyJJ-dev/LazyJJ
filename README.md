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

# Fetch and start a new stack from trunk
jj start

# Make changes to a file
vim src/feature.js

# Commit with message
jj commit -m "Add feature A"

# Create bookmark for this commit
jj create feature-a

# Make more changes
vim src/feature.js

# Commit with message
jj commit -m "Add feature B"

# Create another bookmark
jj create feature-b

# Submit the entire stack to remote
jj stack-submit

# Open PR forms for each bookmark in stack
jj pr-stack-create

# Add stack summary comments to each PR
jj pr-stack-update

# (After first PR is merged on GitHub)
# Fetch and rebase remaining commits
jj sync
```

See the [Quick Start guide](https://lazyjj.dev/quickstart/) for more.

## What You Get

### 📚 Stack Workflow Commands

Navigate and manage stacks of commits for stacked PRs:

**Viewing your stacks:**

| Command            | Shortcut   | Purpose                    |
| ------------------ | ---------- | -------------------------- |
| `stack-view`       | `stack`    | View current stack         |
| `stack-files`      | `stackls`  | View stack with files      |
| `stacks-all`       | `stacks`   | View all your stacks       |
| `stacks-all-files` | `stacksls` | View all stacks with files |

**Navigation & maintenance:**

| Command       | Shortcut | Purpose                      |
| ------------- | -------- | ---------------------------- |
| `stack-top`   | `top`    | Jump to top of stack         |
| `stack-gc`    | `gc`     | Clean up empty commits       |
| `restack`     | -        | Rebase stack onto trunk      |
| `restack-all` | -        | Rebase all stacks onto trunk |

**Bookmark operations:**

| Command  | Shortcut | Purpose                      |
| -------- | -------- | ---------------------------- |
| `create` | -        | Create bookmark at @-        |
| `tug`    | -        | Move bookmark to follow work |

**Syncing & submitting:**

| Command        | Shortcut | Purpose                     |
| -------------- | -------- | --------------------------- |
| `stack-start`  | `start`  | Fetch + new commit on trunk |
| `stack-sync`   | `sync`   | Fetch + rebase onto trunk   |
| `stack-submit` | `ss`     | Push stack to remote        |

**Diffing:**

| Command              | Shortcut | Purpose                       |
| -------------------- | -------- | ----------------------------- |
| `stack-diff`         | -        | Show diff from stack start    |
| `stack-diff-summary` | -        | Diff summary from stack start |
| `stack-diff-files`   | -        | List files changed in stack   |

### 🤖 Claude Code Integration

Streamlined worktree management for AI pair programming:

| Command             | Shortcut    | Purpose                            |
| ------------------- | ----------- | ---------------------------------- |
| `claude-start`      | `clstart`   | Create JJ workspace + tmux session |
| `claude-stop`       | `clstop`    | Stop and clean up workspace        |
| `claude-resolve`    | `clresolve` | AI-assisted conflict resolution    |
| `claude-checkpoint` | -           | Save progress checkpoint           |

### 🔗 GitHub Integration

Create and manage stacked PRs (requires `gh` CLI):

**Viewing PRs:**

| Command   | Shortcut | Purpose            |
| --------- | -------- | ------------------ |
| `pr-view` | `prv`    | View current PR    |
| `pr-open` | `pro`    | Open PR in browser |

**Stacked PR workflow:**

| Command            | Shortcut | Purpose                       |
| ------------------ | -------- | ----------------------------- |
| `pr-stack`         | -        | List bookmarks in stack       |
| `pr-stack-create`  | `sprs`   | Create/update stacked PRs     |
| `pr-stack-summary` | `prs`    | Generate PR stack summary     |
| `pr-stack-update`  | `uprs`   | Update PR comments with stack |

**PR formatting:**

| Command            | Shortcut | Purpose                           |
| ------------------ | -------- | --------------------------------- |
| `pr-stack-md`      | `prmd`   | Format current stack (deprecated) |
| `pr-stacks-all-md` | -        | Format all mutable PRs            |

**Utilities:**

| Command       | Shortcut | Purpose                    |
| ------------- | -------- | -------------------------- |
| `github-repo` | `repo`   | Get owner/repo from remote |
| `gh`          | -        | GitHub CLI wrapper         |

### ⚡ Core Aliases

Essential shortcuts and value-add commands:

| Command        | Shortcut | Purpose              |
| -------------- | -------- | -------------------- |
| `diff-summary` | `diffs`  | Compact diff summary |
| `diff-files`   | `diffls` | List changed files   |
| `log-short`    | -        | Quick log (10 items) |
| `git fetch`    | `gf`     | Fetch from remote    |

### 🔧 Self-Management

Manage LazyJJ itself:

| Command         | Purpose          |
| --------------- | ---------------- |
| `lazyjj`        | Show cheat sheet |
| `lazyjj-update` | Update to latest |

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

## Contributing

Contributions are welcome! This project uses [mise](https://mise.jdx.dev) to manage the development environment.

### Development Setup

1. Install mise:

   ```bash
   curl https://mise.run | sh
   ```

2. Clone the repository and let mise set up your environment:
   ```bash
   jj git clone https://github.com/lazyjj-dev/lazyjj.git
   cd lazyjj
   mise install
   ```

Mise will automatically:

- Install the latest version of `jj`
- Set up the `JJ_CONFIG` environment variable to work with the repository configuration

## Uninstall

```bash
~/.config/jj/lazyjj/install.sh --uninstall
```

## License

MIT
