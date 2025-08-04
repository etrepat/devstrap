#!/usr/bin/env bash
# btop

echo "=> Installing command-line utilities..."
sudo apt-get install -y btop

# Set btop config
mkdir -p ~/.config/btop/themes
cp ${DEVSTRAP_PATH}/config/btop/btop.conf ~/.config/btop/btop.conf
cp ${DEVSTRAP_PATH}/config/btop/tokyo-night.theme ~/.config/btop/themes/tokyo-night.theme
