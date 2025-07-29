#!/usr/bin/env bash
# Terminal utilities

echo "=> Installing terminal utilities..."

yay -Rns --noconfirm htop

yay -S --needed --noconfirm bat btop eza fastfetch fd fzf jq tldr
