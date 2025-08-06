#!/usr/bin/env bash

# Terminal utilities
echo "=> Installing terminal utilities..."
yay -Qq htop && yay -Rns --noconfirm htop
yay -S --needed --noconfirm bat btop chafa eza fastfetch fd fzf jq tldr
