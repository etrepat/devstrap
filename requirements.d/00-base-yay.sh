#!/usr/bin/env bash
# Yay - Yet Another Yaourt

if ! command -v yay &> /dev/null; then
    sudo pacman -S --noconfirm --needed yay
fi
