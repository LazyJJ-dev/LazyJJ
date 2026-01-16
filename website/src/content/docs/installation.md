---
title: Installation
description: How to install LazyJJ
---

## Prerequisites

Before installing LazyJJ, you need:

1. **Jujutsu (JJ)** - Install from [jj-vcs.github.io](https://jj-vcs.github.io/jj/latest/install-and-setup/)
2. **Git** - Required for JJ's git backend
3. **curl** or **wget** - For downloading LazyJJ

Optional but recommended:

- **GitHub CLI (gh)** - For GitHub integration features
- **tmux** - For Claude workspace features

## Quick Install

Run this command in your terminal:

```bash
curl -fsSL https://lazyjj.dev/install.sh | bash
```

This will:

1. Download LazyJJ to `~/.config/jj/lazyjj/`
2. Create symlinks in `~/.config/jj/conf.d/`
3. Verify your JJ installation

## Manual Installation

If you prefer to install manually:

```bash
# Clone the repository
git clone https://github.com/lazyjj-dev/lazyjj.git ~/.config/jj/lazyjj

# Run the install script
cd ~/.config/jj/lazyjj && ./install.sh
```

## What Gets Installed

LazyJJ installs to `~/.config/jj/lazyjj/` and creates symlinks in `~/.config/jj/conf.d/`:

```
~/.config/jj/
├── conf.d/
│   ├── lazyjj-aliases.toml -> ../lazyjj/config/lazyjj-aliases.toml
│   ├── lazyjj-claude.toml -> ../lazyjj/config/lazyjj-claude.toml
│   ├── lazyjj-github.toml -> ../lazyjj/config/lazyjj-github.toml
│   ├── lazyjj-revsets.toml -> ../lazyjj/config/lazyjj-revsets.toml
│   └── lazyjj-stack.toml -> ../lazyjj/config/lazyjj-stack.toml
├── lazyjj/
│   ├── config/
│   │   └── (config files)
│   └── install.sh
└── config.toml  (your personal config - name, email)
```

## Uninstalling

To remove LazyJJ:

```bash
~/.config/jj/lazyjj/install.sh --uninstall
```

This removes the symlinks and the lazyjj directory but preserves your personal config.

## Updating

To update LazyJJ to the latest version:

```bash
cd ~/.config/jj/lazyjj
git pull
./install.sh
```

## Verify Installation

After installing, verify everything works:

```bash
# Check JJ can load the config
jj config list | grep lazyjj

# Try a command
jj status
```

## Troubleshooting

### "jj: command not found"

Make sure JJ is installed and in your PATH:

```bash
which jj
```

If not found, follow the [JJ installation guide](https://jj-vcs.github.io/jj/latest/install-and-setup/).

### Config conflicts

If you have existing JJ config, LazyJJ's settings might conflict. Check your config order:

```bash
ls ~/.config/jj/conf.d/
```

Files are loaded in lexicographic order. To override LazyJJ settings, create a file that sorts after `lazyjj-*` (e.g., `zzz-overrides.toml`).
