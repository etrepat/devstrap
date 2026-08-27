#!/usr/bin/env bash

# Install VirtualBox
echo "=> Installing VirtualBox..."
yay -S --noconfirm --needed virtualbox virtualbox-host-dkms virtualbox-guest-utils
sudo usermod -aG vboxusers "${USER}"
sudo vboxreload
