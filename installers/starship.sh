#!/bin/bash

install_starship() {
    echo "Checking Starship..."

    if command -v starship >/dev/null 2>&1; then
        echo "✓ Starship already installed"
        return 0
    fi

    echo "Installing Starship..."
    if brew install starship; then
        echo "✓ Starship installed"
    else
        echo "✗ Failed to install Starship"
        return 1
    fi
}

setup_starship_config() {
    local dotfiles_dir="$1"
    local source="$dotfiles_dir/configs/starship/starship.toml"
    local config_dir="$HOME/.config"
    local target="$config_dir/starship.toml"

    echo "Setting up Starship config..."

    if [ ! -f "$source" ]; then
        echo "✗ Starship config not found: $source"
        return 1
    fi

    # Crear directorio si no existe
    mkdir -p "$config_dir"

    # Backup existing config if not a symlink
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backed up existing starship.toml"
    fi

    ln -sf "$source" "$target"
    echo "✓ Starship config linked: $target"
}
