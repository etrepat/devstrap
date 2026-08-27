#!/usr/bin/env bash

# Terminal utilities
echo "=> Installing terminal utilities..."
yay -Qq htop && yay -Rns --noconfirm htop
yay -S --needed --noconfirm bat btop chafa direnv eza fastfetch fd fzf jq ripgrep shellcheck shfmt tldr wl-clipboard yq zoxide

# Set eza theme (config/eza-tokyonight.yml is an alternative theme; to switch,
# copy that file here instead of eza.yml)
mkdir -p ~/.config/eza
cp -f "${DEVSTRAP_PATH}/config/eza.yml" ~/.config/eza/theme.yml
