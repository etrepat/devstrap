#!/usr/bin/env bash

# Mise for managing multiple versions of languages
# https://mise.jdx.dev/
echo "=> Installing mise..."
if ! command -v mise &>/dev/null; then
    yay -S --noconfirm --needed mise
    echo "=> Installing usage via mise..."
    mise use -g usage || echo "  (warning: usage install failed — retry with 'mise install usage')"
else
    echo "=> Seems to be already present, skipping..."
fi
