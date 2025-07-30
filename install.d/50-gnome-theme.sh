# Set the gnome theme preferences

# Skip if not in gnome or mandated by user...
[[ "${DEVSTRAP_GNOME_CUSTOMIZE}" != "y" ]] && return 0

echo "=> Setting GNOME fonts..."

# Set Cascadia Mono as the default monospace font
gsettings set org.gnome.desktop.interface monospace-font-name 'CaskaydiaCove Nerd Font 11'

echo "=> Setting GNOME theme..."

THEME_COLOR="purple"
THEME_WALLPAPER="kanagawa.jpg"

WALLPAPER_DST="${HOME}/.local/share/wallpapers"
WALLPAPER_PATH="${WALLPAPER_DST}/${THEME_WALLPAPER}"

gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Yaru'
gsettings set org.gnome.desktop.interface gtk-theme "Yaru-${THEME_COLOR}-dark"
gsettings set org.gnome.desktop.interface icon-theme "Yaru-${THEME_COLOR}"

if [ ! -d "${WALLPAPER_DST}" ]; then
    mkdir -p "${WALLPAPER_DST}"
fi

if [ ! -f "${WALLPAPER_PATH}" ]; then
    cp -f "${DEVSTRAP_PATH}/config/wallpaper/${THEME_WALLPAPER}" ${WALLPAPER_PATH}
fi

gsettings set org.gnome.desktop.background picture-uri ${WALLPAPER_PATH}
gsettings set org.gnome.desktop.background picture-uri-dark ${WALLPAPER_PATH}
gsettings set org.gnome.desktop.background picture-options 'zoom'

# Avatar
sudo cp /usr/share/pixmaps/faces/mountain.jpg /var/lib/AccountsService/icons/$USER
sudo chmod 644 /var/lib/AccountsService/icons/$USER
sudo tee /var/lib/AccountsService/users/$USER > /dev/null <<EOF
[User]
Icon=/var/lib/AccountsService/icons/$USER
EOF
