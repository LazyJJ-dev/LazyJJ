#!/bin/bash
# LazyJJ Installer
# https://lazyjj.dev
#
# Usage:
#   curl -fsSL https://lazyjj.dev/install.sh | bash
#   ./install.sh --uninstall

set -e
set -o pipefail

LAZYJJ_VERSION="${LAZYJJ_VERSION:-latest}"
LAZYJJ_DIR="${HOME}/.config/jj/lazyjj"
CONF_D="${HOME}/.config/jj/conf.d"
FORCE_INSTALL=false
INSTALLATION_STARTED=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() { echo -e "${GREEN}[lazyjj]${NC} $1"; }
warn() { echo -e "${YELLOW}[lazyjj]${NC} $1"; }
error() {
	echo -e "${RED}[lazyjj]${NC} $1"
	exit 1
}

cleanup_on_failure() {
	if [ "$INSTALLATION_STARTED" = true ] && [ $? -ne 0 ]; then
		warn "Installation failed, rolling back changes..."

		# Remove symlinks from conf.d
		if [ -d "$CONF_D" ]; then
			for link in "$CONF_D"/lazyjj-*.toml; do
				if [ -L "$link" ]; then
					rm "$link"
				fi
			done
		fi

		# Remove lazyjj directory
		if [ -d "$LAZYJJ_DIR" ]; then
			rm -rf "$LAZYJJ_DIR"
		fi

		warn "Rollback completed"
	fi
}

trap cleanup_on_failure EXIT

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
	if ! command -v jj &>/dev/null; then
		error "jj (Jujutsu) is not installed. Install it first: https://jj-vcs.github.io/jj/latest/install-and-setup/"
	fi

	# Mark installation as started for rollback purposes
	INSTALLATION_STARTED=true

	# Create directories
	mkdir -p "$LAZYJJ_DIR"
	mkdir -p "$CONF_D"

	# Clone repository or use local directory
	if [ -d "$(dirname "$0")/config" ]; then
		# Local install (development) - we're running from within the repo
		info "Installing from local directory..."
		# Don't copy, just use the existing repo location
		# This path means install.sh is in the repo root or a subdirectory
		SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
		REPO_ROOT="$SCRIPT_DIR"
		# If we're in website/public, go up two levels
		if [ -d "$SCRIPT_DIR/../../config" ]; then
			REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
		fi

		# If LazyJJ_DIR already exists and is not the repo, remove it
		if [ -d "$LAZYJJ_DIR" ] && [ "$LAZYJJ_DIR" != "$REPO_ROOT" ]; then
			rm -rf "$LAZYJJ_DIR"
		fi

		# Create symlink to the repo or copy it
		if [ "$LAZYJJ_DIR" != "$REPO_ROOT" ]; then
			cp -r "$REPO_ROOT" "$LAZYJJ_DIR"
		fi
	else
		# Clone from GitHub
		info "Cloning LazyJJ repository..."

		REPO_URL="https://github.com/lazyjj-dev/lazyjj.git"

		# Remove existing directory if it exists and is not a git/jj repo
		if [ -d "$LAZYJJ_DIR" ]; then
			if [ ! -d "$LAZYJJ_DIR/.jj" ] && [ ! -d "$LAZYJJ_DIR/.git" ]; then
				warn "Removing existing non-repo directory at $LAZYJJ_DIR"
				rm -rf "$LAZYJJ_DIR"
			else
				info "LazyJJ directory already exists as a repository"
				cd "$LAZYJJ_DIR"
				if [ -d ".jj" ]; then
					jj git fetch || error "Failed to update repository"
					jj new trunk || true
				elif [ -d ".git" ]; then
					git pull --ff-only || error "Failed to update repository"
				fi
			fi
		fi

		# Clone if directory doesn't exist
		if [ ! -d "$LAZYJJ_DIR" ]; then
			# Use jj git clone if jj is available (preferred), otherwise fall back to git
			if command -v jj &>/dev/null; then
				jj git clone --no-colocate "$REPO_URL" "$LAZYJJ_DIR" || error "Failed to clone repository from $REPO_URL"
			elif command -v git &>/dev/null; then
				git clone "$REPO_URL" "$LAZYJJ_DIR" || error "Failed to clone repository from $REPO_URL"
			else
				error "Neither jj nor git is installed. Please install jj first."
			fi
		fi
	fi

	# Validate that config files were downloaded/copied
	info "Validating installation..."
	config_count=$(find "$LAZYJJ_DIR/config" -name "lazyjj-*.toml" 2>/dev/null | wc -l)
	if [ "$config_count" -eq 0 ]; then
		error "No config files found after installation. Installation failed."
	fi
	info "Found $config_count config file(s)"

	# Create symlinks
	info "Creating symlinks in conf.d..."
	symlinks_created=0
	for config_file in "$LAZYJJ_DIR/config"/lazyjj-*.toml; do
		if [ -f "$config_file" ]; then
			filename=$(basename "$config_file")
			target_path="$CONF_D/$filename"

			# Check if target exists and is not a symlink
			if [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
				if [ "$FORCE_INSTALL" = true ]; then
					warn "Overwriting existing file: $filename"
					rm "$target_path"
				else
					warn "File $filename already exists and is not a symlink. Skipping..."
					warn "Use --force to overwrite existing files"
					continue
				fi
			fi

			ln -sf "$config_file" "$target_path"
			info "  Linked: $filename"
			symlinks_created=$((symlinks_created + 1))
		fi
	done

	if [ "$symlinks_created" -eq 0 ]; then
		error "No symlinks were created. Installation failed."
	fi

	info ""
	info "LazyJJ installed successfully!"
	info ""
	info "Quick reference: jj lazyjj"
	info "Full docs: https://lazyjj.dev"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
	case "$1" in
	--uninstall)
		uninstall
		exit 0
		;;
	--force)
		FORCE_INSTALL=true
		shift
		;;
	*)
		error "Unknown option: $1\nUsage: $0 [--uninstall] [--force]"
		;;
	esac
done

install
