#!/bin/bash

# Development Environment Setup Script for macOS

echo "Setting up development environment..."
echo ""

# Function to setup dotfiles symlinks
setup_dotfiles() {
    echo "Setting up dotfiles..."

    # Get the directory where this script is located
    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # Create symlink for .zshrc
    if [ -f "$DOTFILES_DIR/.zshrc" ]; then
        # Backup existing .zshrc if it exists and is not a symlink
        if [ -f ~/.zshrc ] && [ ! -L ~/.zshrc ]; then
            echo "Backing up existing .zshrc to .zshrc.backup"
            mv ~/.zshrc ~/.zshrc.backup
        fi

        # Create symlink
        ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
        echo "Symlink created: ~/.zshrc -> $DOTFILES_DIR/.zshrc"
    else
        echo "Warning: .zshrc not found in dotfiles directory"
    fi

    # Create symlink for Ghostty config
    if [ -f "$DOTFILES_DIR/ghostty/config" ]; then
        GHOSTTY_CONFIG_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"

        # Create Ghostty config directory if it doesn't exist
        mkdir -p "$GHOSTTY_CONFIG_DIR"

        # Backup existing config if it exists and is not a symlink
        if [ -f "$GHOSTTY_CONFIG_DIR/config" ] && [ ! -L "$GHOSTTY_CONFIG_DIR/config" ]; then
            echo "Backing up existing Ghostty config to config.backup"
            mv "$GHOSTTY_CONFIG_DIR/config" "$GHOSTTY_CONFIG_DIR/config.backup"
        fi

        # Create symlink
        ln -sf "$DOTFILES_DIR/ghostty/config" "$GHOSTTY_CONFIG_DIR/config"
        echo "Symlink created: $GHOSTTY_CONFIG_DIR/config -> $DOTFILES_DIR/ghostty/config"
    else
        echo "Warning: ghostty/config not found in dotfiles directory"
    fi
}

# Function to install Homebrew if not exists
install_homebrew() {
    if ! command_exists brew; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew already installed"
    fi
}

# Function to install Fira Code
install_fira_code() {
    echo "Checking Fira Code..."

    if ls ~/Library/Fonts/*FiraCode* >/dev/null 2>&1; then
        echo "Fira Code already installed"
        return
    fi

    echo "Installing Fira Code..."
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"

    curl -L -o FiraCode.zip "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip"

    if [ $? -eq 0 ]; then
        unzip -q FiraCode.zip
        cp ttf/*.ttf ~/Library/Fonts/
        echo "Fira Code installed"
    else
        echo "Error downloading Fira Code"
    fi

    cd ~
    rm -rf "$TEMP_DIR"
}

# Function to install fnm (Fast Node Manager)
install_fnm() {
    echo "Checking fnm..."

    if command_exists fnm; then
        echo "fnm already installed"
        return
    fi

    echo "Installing fnm via Homebrew..."
    brew install fnm
    echo "fnm installed (shell configuration detected in dotfiles)"
}

# Function to install Ghostty terminal
install_ghostty() {
    echo "Checking Ghostty..."

    if brew list --cask ghostty >/dev/null 2>&1; then
        echo "Ghostty already installed"
        return
    fi

    echo "Installing Ghostty via Homebrew..."
    brew install --cask ghostty
    echo "Ghostty installed"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main installation sequence
main() {
    setup_dotfiles
    install_homebrew
    install_fira_code
    install_fnm
    install_ghostty

    echo ""
    echo "Setup completed!"
    echo ""
    echo "Next steps:"
    echo "1. Restart your terminal"
    echo "2. Configure VS Code with Fira Code:"
    echo "   - Settings > Editor: Font Family"
    echo "   - Add: 'Fira Code', monospace"
    echo "   - Enable: \"editor.fontLigatures\": true"
    echo "3. Check Node.js: node --version"
    echo "4. Check fnm: fnm list"
}

# Run main function
main
