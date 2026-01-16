#!/bin/bash
# LazyJJ Installer
# https://lazyjj.dev
#
# Usage:
#   curl -fsSL https://lazyjj.dev/install.sh | bash
#   ./install.sh --uninstall

set -e

LAZYJJ_VERSION="${LAZYJJ_VERSION:-latest}"
LAZYJJ_DIR="${HOME}/.config/jj/lazyjj"
CONF_D="${HOME}/.config/jj/conf.d"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[lazyjj]${NC} $1"; }
warn() { echo -e "${YELLOW}[lazyjj]${NC} $1"; }
error() { echo -e "${RED}[lazyjj]${NC} $1"; exit 1; }

uninstall() {
    info "Uninstalling LazyJJ..."

    # Remove symlinks from conf.d
    if [ -d "$CONF_D" ]; then
        for link in "$CONF_D"/lazyjj-*.toml; do
            if [ -L "$link" ]; then
                rm "$link"
                info "Removed symlink: $(basename "$link")"
            fi
        done
    fi

    # Remove lazyjj directory
    if [ -d "$LAZYJJ_DIR" ]; then
        rm -rf "$LAZYJJ_DIR"
        info "Removed $LAZYJJ_DIR"
    fi

    info "LazyJJ uninstalled successfully!"
}

install() {
    info "Installing LazyJJ..."

    # Check for jj
    if ! command -v jj &> /dev/null; then
        error "jj (Jujutsu) is not installed. Install it first: https://jj-vcs.github.io/jj/latest/install-and-setup/"
    fi

    # Create directories
    mkdir -p "$LAZYJJ_DIR"
    mkdir -p "$CONF_D"

    # Download or copy config files
    if [ -d "$(dirname "$0")/config" ]; then
        # Local install (development)
        info "Installing from local directory..."
        cp -r "$(dirname "$0")/config" "$LAZYJJ_DIR/"
    else
        # Download from GitHub releases
        info "Downloading LazyJJ $LAZYJJ_VERSION..."

        if [ "$LAZYJJ_VERSION" = "latest" ]; then
            DOWNLOAD_URL="https://github.com/lazyjj-dev/lazyjj/releases/latest/download/lazyjj-config.tar.gz"
        else
            DOWNLOAD_URL="https://github.com/lazyjj-dev/lazyjj/releases/download/${LAZYJJ_VERSION}/lazyjj-config.tar.gz"
        fi

        if command -v curl &> /dev/null; then
            curl -fsSL "$DOWNLOAD_URL" | tar xz -C "$LAZYJJ_DIR"
        elif command -v wget &> /dev/null; then
            wget -qO- "$DOWNLOAD_URL" | tar xz -C "$LAZYJJ_DIR"
        else
            error "Neither curl nor wget found. Please install one of them."
        fi
    fi

    # Create symlinks
    info "Creating symlinks in conf.d..."
    for config_file in "$LAZYJJ_DIR/config"/lazyjj-*.toml; do
        if [ -f "$config_file" ]; then
            filename=$(basename "$config_file")
            ln -sf "$config_file" "$CONF_D/$filename"
            info "  Linked: $filename"
        fi
    done

    info ""
    info "LazyJJ installed successfully!"
    info ""
    info "Your JJ is now supercharged with:"
    info "  - Core aliases (st, d, l, n, e)"
    info "  - Stack workflow (stack, stacks, top, bottom, sync)"
    info "  - GitHub integration (prv, pro, sprs)"
    info "  - Claude integration (clstart, clstop)"
    info ""
    info "Get started: jj st"
    info "Quick reference: jj lazyjj"
    info "Full docs: https://lazyjj.dev"
}

# Parse arguments
case "${1:-}" in
    --uninstall)
        uninstall
        ;;
    *)
        install
        ;;
esac
