# LazyJJ

A ready-to-use [Jujutsu (JJ)](https://jj-vcs.github.io/jj/) distribution with sensible defaults, powerful aliases, and modern workflows.

## Installation

```bash
curl -fsSL https://lazyjj.dev/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/lazyjj-dev/lazyjj.git ~/.config/jj/lazyjj
cd ~/.config/jj/lazyjj && ./install.sh
```

## What's Included

### Core Aliases

| Alias | Command | Purpose |
|-------|---------|---------|
| `st` | `status` | Quick status |
| `d` | `diff` | View changes |
| `l` | `log --limit 10` | Quick log |
| `ll` | `log` | Full log |
| `n` | `new` | New commit |
| `e` | `edit` | Edit commit |

### Stack Workflow

| Alias | Purpose |
|-------|---------|
| `stack` | View current stack with trunk |
| `stacks` | View all your stacks |
| `top` | Jump to top of stack |
| `bottom` | Jump to bottom of stack |
| `sync` | Fetch and restack onto trunk |
| `start` | Fetch and start fresh from trunk |

### GitHub Integration

| Alias | Purpose |
|-------|---------|
| `prv` | View current PR |
| `pro` | Open current PR in browser |
| `sprs` | Create/update stacked PRs |
| `prs` | Generate PR stack summary |

### Claude Integration

| Alias | Purpose |
|-------|---------|
| `clstart` | Create JJ workspace + tmux session for Claude |
| `clstop` | Stop and clean up Claude workspace |
| `clresolve` | Resolve conflicts using Claude |
| `clreview` | Review a PR using Claude |

## Configuration

LazyJJ installs to `~/.config/jj/lazyjj/` and symlinks config files to `~/.config/jj/conf.d/`. JJ loads all `.toml` files from `conf.d/` in lexicographic order.

Your personal config (name, email) stays in `~/.config/jj/config.toml`.

## Uninstall

```bash
~/.config/jj/lazyjj/install.sh --uninstall
```

## License

MIT
