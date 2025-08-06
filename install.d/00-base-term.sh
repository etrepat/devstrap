#!/usr/bin/env bash

# Install a better term - Ghostty
echo "=> Installing terminal application (ghostty)..."
yay -S --noconfirm --needed ghostty

# Set some defaults
mkdir -p ~/.config/ghostty
cp -f "${DEVSTRAP_PATH}/config/ghostty.conf" ~/.config/ghostty/config
