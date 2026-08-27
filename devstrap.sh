#!/usr/bin/env bash

# Exit inmediately
set -e

# Reset sudo credentials & ask for password preemptively
sudo -K && sudo -v

# Sudo keep-alive (re-authenticate on expiry instead of dying)
(while true; do sudo -n true 2>/dev/null; sleep 60; done) &
export DEVSTRAP_SUDO_KEEPALIVE=$!

# Setup
export DEVSTRAP_TMP="${DEVSTRAP_TMP:-/tmp}"
export DEVSTRAP_PATH="${DEVSTRAP_PATH:-${DEVSTRAP_TMP}/devstrap}"

# Inform on if something failed
restore_gnome_session_settings() {
    if [[ "${DEVSTRAP_USING_GNOME:-false}" != "true" ]]; then
        return 0
    fi

    if [[ -n "${DEVSTRAP_GNOME_LOCK_ENABLED:-}" ]]; then
        gsettings set org.gnome.desktop.screensaver lock-enabled "${DEVSTRAP_GNOME_LOCK_ENABLED}" || true
    fi

    if [[ -n "${DEVSTRAP_GNOME_IDLE_DELAY:-}" ]]; then
        gsettings set org.gnome.desktop.session idle-delay "${DEVSTRAP_GNOME_IDLE_DELAY}" || true
    fi
}

cleanup_handler() {
    kill "${DEVSTRAP_SUDO_KEEPALIVE}" 2>/dev/null || true
    restore_gnome_session_settings
}

error_handler() {
    echo -e "\e[31;1mInstall failed\e[0m"
    echo -e "You may run the install scripts individually or retry by running: \e[33;1m$DEVSTRAP_PATH/install.sh\e[0m"
}

trap error_handler ERR
trap cleanup_handler EXIT INT TERM

# Perform os-specific checks here
. ${DEVSTRAP_PATH}/os-checks.sh

# Load shared helpers
for helper in ${DEVSTRAP_PATH}/helpers.d/*.sh; do . $helper; done

# Bootstrap required tooling
echo -e "\e[33;1m~>\e[0m Initializing..."
for req in ${DEVSTRAP_PATH}/requirements.d/*.sh; do . $req; done

# Installation
clear; echo -e "\n\e[36;1mdevstrap\e[0m\n"
if ! gum confirm "This script will bootstrap a freshly installed machine w/several configuration choices. Proceed?"; then
    echo -e "\e[33;1m~>\e[0m Installation cancelled."
    exit 0
fi

# Identify user (for git config)
export DEVSTRAP_USERNAME=$(gum input --placeholder "Enter full name" --prompt "Name> ")
export DEVSTRAP_USER_EMAIL=$(gum input --placeholder "Enter email address" --prompt "Email> ")

# Ask the user to select which programming languages to install
devstrap_prompt_langs

# Ask the user it it wants to apply GNOME settings & customizations (if using gnome) ?
DEVSTRAP_USING_GNOME=$([[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && echo true || echo false)
export DEVSTRAP_GNOME_CUSTOMIZE=$(${DEVSTRAP_USING_GNOME} && gum confirm "Apply GNOME theme & customizations (including extensions)?" && echo 'y')

if [ "$DEVSTRAP_USING_GNOME" = true ]; then
    export DEVSTRAP_GNOME_LOCK_ENABLED="$(gsettings get org.gnome.desktop.screensaver lock-enabled || true)"
    export DEVSTRAP_GNOME_IDLE_DELAY="$(gsettings get org.gnome.desktop.session idle-delay || true)"

    # Ensure computer doesn't go to sleep or lock while installing
    gsettings set org.gnome.desktop.screensaver lock-enabled false
    gsettings set org.gnome.desktop.session idle-delay 0
fi

# Update & upgrade packages before installing anything
gum spin --title "Upgrading base system, this may take a while..." -- yay -Syu --noconfirm > /dev/null

# Run installers
for installer in ${DEVSTRAP_PATH}/install.d/*.sh; do
    . $installer
done

if [ "$DEVSTRAP_USING_GNOME" = true ]; then
    # Revert to normal idle and lock settings
    gsettings set org.gnome.desktop.screensaver lock-enabled "${DEVSTRAP_GNOME_LOCK_ENABLED:-false}"
    gsettings set org.gnome.desktop.session idle-delay "${DEVSTRAP_GNOME_IDLE_DELAY:-300}"
fi

echo -e "\e[33;1m~>\e[0m Doing cleanup..."

orphaned="$(yay -Qdtq || true)"
if [[ -n "${orphaned}" ]]; then
    yay -Rns --noconfirm ${orphaned}
fi
yay -Sc --noconfirm
yay -Syu --noconfirm

echo -e "\e[33;1m~>\e[0m Removing artifacts..."
rm -fr ${DEVSTRAP_PATH}

unset DEVSTRAP_GNOME_LOCK_ENABLED
unset DEVSTRAP_GNOME_IDLE_DELAY
unset DEVSTRAP_GNOME_CUSTOMIZE
unset DEVSTRAP_SELECTED_LANGS
unset DEVSTRAP_USER_EMAIL
unset DEVSTRAP_USERNAME
unset DEVSTRAP_PATH
unset DEVSTRAP_TMP

echo -e "\e[32;1m~>\e[0m All done."
gum confirm "It is recommended to reboot the system to apply all the changes. Reboot now?" && sudo shutdown -r now
