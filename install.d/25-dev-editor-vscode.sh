#!/usr/bin/env bash

# Visual Studio Code (if selected)
devstrap_prompt_editors
if ! devstrap_editor_selected "Visual Studio Code"; then
    return 0
fi

echo "=> Install Visual Studio Code..."
yay -S --noconfirm --needed visual-studio-code-bin

echo "=> Copying base config..."
mkdir -p ~/.config/Code/User
[ -f "$HOME/.config/Code/User/settings.json" ] && mv ~/.config/Code/User/settings.json ~/.config/Code/User/settings.json.bak
cp -f "${DEVSTRAP_PATH}/config/vscode.json" ~/.config/Code/User/settings.json

# Install base extension set
echo "=> Installing base extensions..."
code --install-extension Catppuccin.catppuccin-vsc
code --install-extension ms-azuretools.vscode-docker
code --install-extension EditorConfig.EditorConfig
code --install-extension eamodio.gitlens
code --install-extension mikestead.dotenv

# Add language extensions for the selected languages
echo "=> Installing language extensions (if selected)..."

# Elixir
if devstrap_lang_selected "Elixir"; then
    code --install-extension JakeBecker.elixir-ls
fi

# Go
if devstrap_lang_selected "Go"; then
    code --install-extension golang.go
fi

# Java
if devstrap_lang_selected "Java"; then
    code --install-extension redhat.java
fi

# Node.js
if devstrap_lang_selected "Node.js"; then
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension esbenp.prettier-vscode
fi

# PHP (Intelephense)
if devstrap_lang_selected "PHP"; then
    code --install-extension bmewburn.vscode-intelephense-client
fi

# Python
if devstrap_lang_selected "Python"; then
    code --install-extension ms-python.python
fi

# Ruby
if devstrap_lang_selected "Ruby"; then
    code --install-extension castwide.solargraph
fi

# Rust
if devstrap_lang_selected "Rust"; then
    code --install-extension rust-lang.rust-analyzer
fi