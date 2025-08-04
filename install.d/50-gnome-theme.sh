#!/usr/bin/env bash
# Set the gnome theme preferences

# Skip if not in gnome or mandated by user...
[[ "${DEVSTRAP_GNOME_CUSTOMIZE}" != "y" ]] && return 0

THEME_WALLPAPER="abstract-purple-blue.jpg"

echo "=> Setting GNOME fonts..."

# Set Noto Sans as the default font
# gsettings set org.gnome.desktop.interface font-name 'Noto Sans 11'
gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans 11'

# Set Cascadia Mono as the default monospace font
gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaCove Nerd Font 11'

echo "=> Setting GNOME theme..."

# Prefer dark & accent color
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface accent-color 'purple'

# Wallpaper
mkdir -p ~/.local/share/wallpapers

if [ ! -f "~/.local/share/wallpapers/${THEME_WALLPAPER}" ]; then
    cp -f "${DEVSTRAP_PATH}/config/wallpaper/${THEME_WALLPAPER}" ~/.local/share/wallpapers/${THEME_WALLPAPER}
fi

gsettings set org.gnome.desktop.background picture-uri "${HOME}/.local/share/wallpapers/${THEME_WALLPAPER}"
gsettings set org.gnome.desktop.background picture-uri-dark "${HOME}/.local/share/wallpapers/${THEME_WALLPAPER}"
gsettings set org.gnome.desktop.background picture-options 'zoom'

# Avatar
sudo cp /usr/share/pixmaps/faces/mountain.jpg /var/lib/AccountsService/icons/$USER
sudo chmod 644 /var/lib/AccountsService/icons/$USER
sudo tee /var/lib/AccountsService/users/$USER > /dev/null <<EOF
[User]
Icon=/var/lib/AccountsService/icons/$USER
EOF
