#!/usr/bin/env bash
# Install bluetooth minimal stack & turn on bluetooth by default

yay -S --needed --noconfirm bluez bluez-utils
sudo systemctl enable --now bluetooth.service
