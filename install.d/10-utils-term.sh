#!/usr/bin/env bash

# Terminal utilities
echo "=> Installing terminal utilities..."
yay -Qq htop && yay -Rns --noconfirm htop
yay -S --needed --noconfirm bat btop chafa eza fastfetch fd fzf jq tldr wl-clipboard zoxide

# Set eza theme
mkdir -p ~/.config/eza
cp -f "${DEVSTRAP_PATH}/config/eza.yml" ~/.config/eza/theme.yml
