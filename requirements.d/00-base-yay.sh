#!/usr/bin/env bash
# Yay - Yet Another Yaourt

DEVSTRAP_TMP="${DEVSTRAP_TMP:-/tmp}"

if ! command -v yay &> /dev/null; then
    cd ${DEVSTRAP_TMP}
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ${DEVSTRAP_TMP}
    rm -rf yay-bin

    # Add fun and color to the pacman installer
    sudo sed -i '/^\[options\]/a Color\nILoveCandy' /etc/pacman.conf
fi
