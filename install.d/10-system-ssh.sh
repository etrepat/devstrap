#!/usr/bin/env bash

# Configure GNOME keyring as wrapper around ssh-agent
systemctl --user enable gcr-ssh-agent.socket
systemctl --user start gcr-ssh-agent.socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"

# Also, install GNOME Seahorse utility
yay -S --noconfirm seahorse
