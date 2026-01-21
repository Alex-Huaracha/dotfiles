#!/bin/bash

install_homebrew() {
    echo "Checking Homebrew..."

    if command -v brew >/dev/null 2>&1; then
        echo "✓ Homebrew already installed"
        return 0
    fi

    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if command -v brew >/dev/null 2>&1; then
        echo "✓ Homebrew installed"
    else
        echo "✗ Failed to install Homebrew"
        return 1
    fi
}
