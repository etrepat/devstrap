#!/usr/bin/env bash

# Mise for managing multiple versions of languages
# https://mise.jdx.dev/
echo "=> Installing mise..."
if ! command -v mise &> /dev/null; then
    yay -S --noconfirm --needed mise
else
    echo "=> Seems to be already present, skipping..."
fi
