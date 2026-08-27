#!/usr/bin/env bash

# Install fonts from the Arch extra repos (more maintainable than manual downloads)
echo "=> Installing fonts..."
yay -S --noconfirm --needed otf-font-awesome noto-fonts noto-fonts-emoji noto-fonts-extra noto-fonts-cjk ttc-iosevka ttf-iosevkaterm-nerd
