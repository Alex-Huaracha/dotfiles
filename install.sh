#!/bin/bash
set -e  # Exit on error

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source installers
source "$SCRIPT_DIR/installers/homebrew.sh"
source "$SCRIPT_DIR/installers/ghostty.sh"
source "$SCRIPT_DIR/installers/fonts.sh"

# Setup zshrc
setup_zsh() {
    local source="$SCRIPT_DIR/configs/zsh/.zshrc"
    local target="$HOME/.zshrc"

    echo "Setting up zsh config..."

    if [ ! -f "$source" ]; then
        echo "✗ .zshrc not found: $source"
        return 1
    fi

    # Backup existing config if not a symlink
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backed up existing .zshrc"
    fi

    ln -sf "$source" "$target"
    echo "✓ .zshrc linked: $target"
}

# Main installation
main() {
    echo "========================================"
    echo "  Development Environment Setup"
    echo "========================================"
    echo ""

    install_homebrew
    echo ""

    install_fira_code
    install_iosevka_nerd_font
    echo ""

    install_ghostty
    setup_ghostty_config "$SCRIPT_DIR"
    echo ""

    setup_zsh
    echo ""

    echo "========================================"
    echo "✓ Setup completed!"
    echo "========================================"
    echo ""
    echo "Next steps:"
    echo "1. Restart your terminal"
    echo "2. Verify installations:"
    echo "   brew --version"
    echo "   ghostty --version"
}

main "$@"
# Function to install fnm (Fast Node Manager)
# install_fnm() {
#     echo "Checking fnm..."

#     if command_exists fnm; then
#         echo "fnm already installed"
#         return
#     fi

#     echo "Installing fnm via Homebrew..."
#     brew install fnm
#     echo "fnm installed (shell configuration detected in dotfiles)"
# }
