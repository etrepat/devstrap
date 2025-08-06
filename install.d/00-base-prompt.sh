#!/usr/bin/env bash

# Use starship.rs for prompt support
echo "=> Installing Starship.rs..."

if ! command -v starship &> /dev/null; then
    yay -S --noconfirm --needed starship
else
    echo "=> It seems that Starship.rs is already present in the system..."
fi

echo "=> Bootstraping Starship.rs config..."
mkdir -p ~/.config
[ -f "~/.config/starship.toml" ] && mv ~/.config/starship.toml ~/.config/starship.toml.bak
cp -f "${DEVSTRAP_PATH}/config/starship.toml" ~/.config/starship.toml
