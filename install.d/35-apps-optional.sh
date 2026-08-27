#!/usr/bin/env bash

# Optional desktop apps (user-selectable at install time)
devstrap_prompt_optional_apps

for app in ${DEVSTRAP_SELECTED_OPTIONAL_APPS}; do
    case $app in
        "OBS Studio")
            echo "=> Installing OBS Studio..."
            yay -S --noconfirm --needed obs-studio
            ;;
        GIMP)
            echo "=> Installing GIMP..."
            yay -S --noconfirm --needed gimp
            ;;
        Inkscape)
            echo "=> Installing Inkscape..."
            yay -S --noconfirm --needed inkscape
            ;;
        Steam)
            echo "=> Installing Steam (enabling multilib)..."
            # Steam needs the multilib repo for its 32-bit runtime
            if ! grep -q '^\[multilib\]' /etc/pacman.conf; then
                if grep -q '^#\[multilib\]' /etc/pacman.conf; then
                    sudo sed -i 's/^#\[multilib\]/[multilib]/; s|^#Include = /etc/pacman.d/mirrorlist|Include = /etc/pacman.d/mirrorlist|' /etc/pacman.conf
                else
                    printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' | sudo tee -a /etc/pacman.conf >/dev/null
                fi
                sudo pacman -Sy --noconfirm
            fi
            yay -S --noconfirm --needed steam
            ;;
    esac
done
