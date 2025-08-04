#!/usr/bin/env bash

# Copy bash config
echo "=> Copying bash settings (~/.bashrc)..."

[ -f "~/.bash_aliases" ] && mv ~/.bash_aliases ~/.bash_aliases.bak
cp -f "${DEVSTRAP_PATH}/config/bash_aliases" ~/.bash_aliases

[ -f "~/.zshrc" ] && mv ~/.zshrc ~/.zshrc.bak
cp -f "${DEVSTRAP_PATH}/config/zshrc" ~/.zshrc

[ -f "~/.inputrc" ] && mv ~/.inputrc ~/.inputrc.bak
cp "${DEVSTRAP_PATH}/config/inputrc" ~/.inputrc

# Set btop config
echo "=> Setting btop config (~/config/btop/btop.conf)..."
mkdir -p ~/.config/btop/themes
cp ${DEVSTRAP_PATH}/config/btop/btop.conf ~/.config/btop/btop.conf
cp ${DEVSTRAP_PATH}/config/btop/tokyo-night.theme ~/.config/btop/themes/tokyo-night.theme
