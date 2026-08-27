#!/usr/bin/env bash

# Exit inmediately
set -e

# Reset sudo credentials & ask for password preemptively
sudo -K && sudo -v

# Sudo keep-alive (re-authenticate on expiry instead of dying)
(while true; do
    sudo -n true 2>/dev/null
    sleep 60
done) &
export DEVSTRAP_SUDO_KEEPALIVE=$!

# Setup
export DEVSTRAP_TMP="${DEVSTRAP_TMP:-/tmp}"
export DEVSTRAP_PATH="${DEVSTRAP_PATH:-${DEVSTRAP_TMP}/devstrap}"

# Perform os-specific checks here
. "${DEVSTRAP_PATH}/os-checks.sh"

# Load shared helpers
for helper in "${DEVSTRAP_PATH}"/helpers.d/*.sh; do
    # shellcheck disable=SC1090
    . "${helper}"
done

# Set traps now that the handlers (helpers.d) are loaded
trap error_handler ERR
trap cleanup_handler EXIT INT TERM

# Bootstrap required tooling
echo -e "\e[33;1m~>\e[0m Initializing..."
for req in "${DEVSTRAP_PATH}"/requirements.d/*.sh; do
    # shellcheck disable=SC1090
    . "${req}"
done

# Installation
clear
echo -e "\n\e[36;1mdevstrap\e[0m\n"
if ! gum confirm "This script will bootstrap a freshly installed machine w/several configuration choices. Proceed?"; then
    echo -e "\e[33;1m~>\e[0m Installation cancelled."
    exit 0
fi

# Identify user (for git config)
DEVSTRAP_USERNAME=$(gum input --placeholder "Enter full name" --prompt "Name> ") || true
export DEVSTRAP_USERNAME
DEVSTRAP_USER_EMAIL=$(gum input --placeholder "Enter email address" --prompt "Email> ") || true
export DEVSTRAP_USER_EMAIL

# Ask the user to select which programming languages to install
devstrap_prompt_langs

# Ask the user to select the editor(s) to install
devstrap_prompt_editors

# Ask the user to select optional desktop apps
devstrap_prompt_optional_apps

# Ask the user it it wants to apply GNOME settings & customizations (if using gnome) ?
DEVSTRAP_USING_GNOME=$([[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && echo true || echo false)
DEVSTRAP_GNOME_CUSTOMIZE=$(${DEVSTRAP_USING_GNOME} && gum confirm "Apply GNOME theme & customizations (including extensions)?" && echo 'y') || true
export DEVSTRAP_GNOME_CUSTOMIZE

if [ "$DEVSTRAP_USING_GNOME" = true ]; then
    DEVSTRAP_GNOME_LOCK_ENABLED="$(gsettings get org.gnome.desktop.screensaver lock-enabled || true)"
    export DEVSTRAP_GNOME_LOCK_ENABLED
    DEVSTRAP_GNOME_IDLE_DELAY="$(gsettings get org.gnome.desktop.session idle-delay || true)"
    export DEVSTRAP_GNOME_IDLE_DELAY

    # Ensure computer doesn't go to sleep or lock while installing
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    gsettings set org.gnome.desktop.session idle-delay 0
fi

# Update & upgrade packages before installing anything
gum spin --title "Upgrading base system, this may take a while..." -- yay -Syu --noconfirm >/dev/null

# Run installers (defined in helpers.d/30-installer-runner.sh)
run_installers

if [ "$DEVSTRAP_USING_GNOME" = true ]; then
    # Revert to normal idle and lock settings
    gsettings set org.gnome.desktop.screensaver lock-enabled "${DEVSTRAP_GNOME_LOCK_ENABLED:-false}"
    gsettings set org.gnome.desktop.session idle-delay "${DEVSTRAP_GNOME_IDLE_DELAY:-300}"
fi

echo -e "\e[33;1m~>\e[0m Doing cleanup..."

orphaned=()
mapfile -t orphaned < <(yay -Qdtq || true)
if ((${#orphaned[@]} > 0)); then
    yay -Rns --noconfirm "${orphaned[@]}"
fi
yay -Sc --noconfirm
yay -Syu --noconfirm

echo -e "\e[33;1m~>\e[0m Removing artifacts..."
rm -fr "${DEVSTRAP_PATH}"

unset DEVSTRAP_GNOME_LOCK_ENABLED
unset DEVSTRAP_GNOME_IDLE_DELAY
unset DEVSTRAP_GNOME_CUSTOMIZE
unset DEVSTRAP_SELECTED_LANGS
unset DEVSTRAP_SELECTED_EDITORS
unset DEVSTRAP_SELECTED_OPTIONAL_APPS
unset DEVSTRAP_USER_EMAIL
unset DEVSTRAP_USERNAME
unset DEVSTRAP_PATH
unset DEVSTRAP_TMP

echo -e "\e[32;1m~>\e[0m All done."
gum confirm "It is recommended to reboot the system to apply all the changes. Reboot now?" && sudo shutdown -r now
