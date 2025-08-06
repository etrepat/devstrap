#!/usr/bin/env bash

# Albert launcher
# https://albertlauncher.github.io/
echo "=> Installing Albert launcher..."
yay -S --noconfirm --needed albert

# Add to autostart
mkdir -p ~/.config/autostart
cp -f /usr/share/applications/albert.desktop ~/.config/autostart/albert.desktop
sed -i '${/^$/d;}' ~/.config/autostart/albert.desktop && \
    echo 'X-GNOME-Autostart-enabled=true' >> ~/.config/autostart/albert.desktop
