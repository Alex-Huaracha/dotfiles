#!/bin/bash

get_fonts_dir() {
    case "$(uname -s)" in
        Darwin) echo "$HOME/Library/Fonts" ;;
        Linux) echo "$HOME/.local/share/fonts" ;;
        *) echo "✗ Unsupported OS"; return 1 ;;
    esac
}

install_font_from_zip() {
    local name="$1"
    local url="$2"

    echo "Checking $name..."

    local fonts_dir
    fonts_dir=$(get_fonts_dir) || return 1

    if ls "$fonts_dir"/*"$name"* >/dev/null 2>&1; then
        echo "✓ $name already installed"
        return 0
    fi

    echo "Installing $name..."

    local temp_dir
    temp_dir=$(mktemp -d)

    (
        cd "$temp_dir" || exit 1

        if ! curl -L -o font.zip "$url"; then
            echo "✗ Failed to download $name"
            exit 1
        fi

        if ! unzip -q font.zip; then
            echo "✗ Failed to unzip $name"
            exit 1
        fi

        # Try to copy from ttf/ first, then from root
        if ! cp ttf/*.ttf "$fonts_dir/" 2>/dev/null && ! cp *.ttf "$fonts_dir/" 2>/dev/null; then
            echo "✗ Failed to copy fonts"
            exit 1
        fi
    )

    local exit_code=$?
    rm -rf "$temp_dir"

    if [ $exit_code -eq 0 ]; then
        echo "✓ $name installed"

        # Update font cache on Linux/WSL
        if [ "$(uname -s)" = "Linux" ]; then
            fc-cache -f >/dev/null 2>&1
        fi
    else
        echo "✗ Failed to install $name"
        return 1
    fi
}

install_fira_code() {
    install_font_from_zip "FiraCode" \
        "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip"
}

install_iosevka_nerd_font() {
    install_font_from_zip "Iosevka" \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/IosevkaTerm.zip"
}

