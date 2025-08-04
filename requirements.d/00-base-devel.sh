#!/usr/bin/env bash
# Add base-devel and git to the system if they are not already installed

sudo pacman -S --needed --noconfirm base-devel

if command -v git &> /dev/null; then
    sudo pacman -S --noconfirm --needed git > /dev/null
fi
