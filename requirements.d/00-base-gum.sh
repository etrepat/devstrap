#!/usr/bin/env bash
# Gum is used as TUI frontend for confirmations, option selection & messaging

if ! command -v gum &> /dev/null; then
    sudo pacman -S --noconfirm --needed gum
fi
