#!/bin/bash

install_ghostty() {
    echo "Checking Ghostty..."

    if brew list --cask ghostty >/dev/null 2>&1; then
        echo "✓ Ghostty already installed"
        return 0
    fi

    echo "Installing Ghostty..."
    if brew install --cask ghostty; then
        echo "✓ Ghostty installed"
    else
        echo "✗ Failed to install Ghostty"
        return 1
    fi
}

setup_ghostty_config() {
    local dotfiles_dir="$1"
    local source="$dotfiles_dir/configs/ghostty/config"

    # Detectar OS para config directory
    case "$(uname -s)" in
        Darwin)
            local config_dir="$HOME/Library/Application Support/com.mitchellh.ghostty"
            ;;
        Linux)
            local config_dir="$HOME/.config/ghostty"
            ;;
        *)
            echo "✗ Unsupported OS for Ghostty config"
            return 1
            ;;
    esac

    echo "Setting up Ghostty config..."

    if [ ! -f "$source" ]; then
        echo "✗ Config not found: $source"
        return 1
    fi

    mkdir -p "$config_dir"

    local target="$config_dir/config"

    # Backup existing config if not a symlink
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backed up existing config"
    fi

    ln -sf "$source" "$target"
    echo "✓ Ghostty config linked: $target"
}
