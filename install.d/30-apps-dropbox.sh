#!/usr/bin/env bash

# Dropbox
echo "=> Installing Dropbox..."
yay -S --noconfirm --needed gpgme python-gpgme dropbox
# gtk-launch dropbox.desktop
