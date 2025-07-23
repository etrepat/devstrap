#!/usr/bin/env bash
# Visual Studio Code

echo "=> Install Visual Studio Code..."
yay -S --noconfirm --needed visual-studio-code-bin

echo "=> Copying base config..."
mkdir -p ~/.config/Code/User
[ -f "~/.config/Code/User/settings.json" ] && mv ~/.config/Code/User/settings.json ~/.config/Code/User/settings.json.bak
cp -f "${DEVSTRAP_PATH}/config/vscode.json" ~/.config/Code/User/settings.json

# Install default extension set
echo "=> Installing base extensions..."
code --install-extension enkia.tokyo-night
code --install-extension vscode-icons-team.vscode-icons
code --install-extension ms-azuretools.vscode-docker
code --install-extension EditorConfig.EditorConfig
code --install-extension eamodio.gitlens
code --install-extension mikestead.dotenv

# Add lang extensions
echo "=> Installing language extensions (if selected)..."

# Go
if [[ -n "$DEVSTRAP_SELECTED_LANGS" && " $DEVSTRAP_SELECTED_LANGS " =~ [[:space:]]Go[[:space:]] ]]; then
    code --install-extension golang.go
fi


# PHP (Intelephense)
if [[ -n "$DEVSTRAP_SELECTED_LANGS" && " $DEVSTRAP_SELECTED_LANGS " =~ [[:space:]]PHP[[:space:]] ]]; then
    code --install-extension bmewburn.vscode-intelephense-client
fi


# Rust analyzer
if [[ -n "$DEVSTRAP_SELECTED_LANGS" && " $DEVSTRAP_SELECTED_LANGS " =~ [[:space:]]Rust[[:space:]] ]]; then
    code --install-extension rust-lang.rust-analyzer
fi
