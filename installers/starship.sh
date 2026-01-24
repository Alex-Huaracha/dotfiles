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
