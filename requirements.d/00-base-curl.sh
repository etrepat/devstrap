#!/usr/bin/env bash
# Curl - A command-line tool for transferring data with URLs

if ! command -v curl &> /dev/null; then
    sudo pacman -S --noconfirm curl > /dev/null
fi
