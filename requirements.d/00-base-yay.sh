#!/usr/bin/env bash
# Yay - Yet Another Yaourt

DEVSTRAP_TMP="${DEVSTRAP_TMP:-/tmp}"

if ! command -v yay &>/dev/null; then
    # Run in a subshell so the cd is confined to the build
    (
        cd "${DEVSTRAP_TMP}" || exit 1
        git clone https://aur.archlinux.org/yay-bin.git
        cd yay-bin || exit 1
        makepkg -si --noconfirm
        cd .. || exit 1
        rm -rf yay-bin
    )

    # Add fun and color to the pacman installer
    sudo sed -i '/^\[options\]/a Color\nILoveCandy' /etc/pacman.conf
fi
