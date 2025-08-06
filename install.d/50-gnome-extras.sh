#!/usr/bin/env bash
# Add some extra GNOME tools & utilities for a better experience

# Skip if not in gnome or mandated by user...
[[ "${DEVSTRAP_GNOME_CUSTOMIZE}" != "y" ]] && return 0

echo "=> Add useful GNOME tools & utilities..."

# Remove un-needed packages
yay -Qq epiphany && yay -Rns --noconfirm epiphany
yay -Qq gnome-tour && yay -Rns --noconfirm gnome-tour
yay -Qq gnome-console && yay -Rns --noconfirm gnome-console

# Install some GNOME utilities
yay -S --noconfirm --needed authenticator collision curtail fragments impression pika-backup
