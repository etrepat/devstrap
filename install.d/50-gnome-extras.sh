#!/usr/bin/env bash
# Add some extra GNOME tools & utilities for a better experience

# Skip if not in gnome or mandated by user...
[[ "${DEVSTRAP_GNOME_CUSTOMIZE}" != "y" ]] && return 0

echo "=> Add useful GNOME tools & utilities..."

# Remove un-needed packages
yay -Rns --noconfirm gnome-console gnome-tour manjaro-hello

# Install some GNOME utilities
yay -S --noconfirm --needed authenticator curtail impression
