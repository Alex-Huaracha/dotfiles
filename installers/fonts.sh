#!/bin/bash

# Detectar directorio de fuentes según OS
get_fonts_dir() {
    case "$(uname -s)" in
        Darwin)
            echo "$HOME/Library/Fonts"
            ;;
        Linux)
            echo "$HOME/.local/share/fonts"
            ;;
        *)
            echo "✗ Unsupported OS for fonts"
            return 1
            ;;
    esac
}

install_fira_code() {
    echo "Checking Fira Code..."

    local fonts_dir
    fonts_dir=$(get_fonts_dir) || return 1

    # Verificar si ya está instalada
    if ls "$fonts_dir"/*FiraCode* >/dev/null 2>&1; then
        echo "✓ Fira Code already installed"
        return 0
    fi

    echo "Installing Fira Code..."

    local temp_dir
    temp_dir=$(mktemp -d)

    # Usar subshell para aislar el cd
    (
        cd "$temp_dir" || exit 1

        if ! curl -L -o FiraCode.zip "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip"; then
            echo "✗ Failed to download Fira Code"
            exit 1
        fi

        if ! unzip -q FiraCode.zip; then
            echo "✗ Failed to unzip Fira Code"
            exit 1
        fi

        if ! cp ttf/*.ttf "$fonts_dir/"; then
            echo "✗ Failed to copy fonts"
            exit 1
        fi
    )

    local exit_code=$?
    rm -rf "$temp_dir"

    if [ $exit_code -eq 0 ]; then
        echo "✓ Fira Code installed"

        # Actualizar cache de fuentes en Linux
        if [ "$(uname -s)" = "Linux" ]; then
            fc-cache -f >/dev/null 2>&1
        fi
    else
        echo "✗ Failed to install Fira Code"
        return 1
    fi
}
