#!/usr/bin/env bash

# Exit inmediately
set -e

# Reset sudo credentials & ask for password preemptively
sudo -K && sudo -v

# Sudo keep-alive
(while true; do sudo -nv; sleep 1m; done) &
export DEVSTRAP_SUDO_KEEPALIVE=$!
trap 'kill $DEVSTRAP_SUDO_KEEPALIVE' INT TERM EXIT ERR

# Setup
export DEVSTRAP_TMP="${DEVSTRAP_TMP:-/tmp}"
export DEVSTRAP_PATH="${DEVSTRAP_PATH:-${DEVSTRAP_TMP}/devstrap}"
export DEVSTRAP_GUM="${DEVSTRAP_GUM:-${DEVSTRAP_TMP}/gum}"

# Bootstrap required tooling
clear; echo "=> Initializing..."
for req in ${DEVSTRAP_PATH}/requirements.d/*.sh; do . $req; done

# Installation
clear; echo -e "\e[33;1mdevstrap\e[0m"
if ${DEVSTRAP_GUM} confirm "This script will bootstrap a freshly installed machine w/several configuration choices. Proceed?"; then
    # Identify user (for git config)
    export DEVSTRAP_USERNAME=$(${DEVSTRAP_GUM} input --placeholder "Enter full name" --prompt "Name> ")
    export DEVSTRAP_USER_EMAIL=$(${DEVSTRAP_GUM} input --placeholder "Enter email address" --prompt "Email> ")

    # Ask the user to select which programming languages to install
    DEVSTRAP_AVAILABLE_LANGS=("Elixir" "Go" "Java" "Node.js" "PHP" "Python" "Ruby" "Rust")
    DEVSTRAP_DEFAULT_LANGS="Node.js","PHP"
    export DEVSTRAP_SELECTED_LANGS=$(${DEVSTRAP_GUM} choose "${DEVSTRAP_AVAILABLE_LANGS[@]}" --no-limit --selected "${DEVSTRAP_DEFAULT_LANGS}" --height 10 --header "Please, select the programming languages to install")

    # Ask the user it it wants to apply GNOME settings & customizations (if using gnome) ?
    DEVSTRAP_USING_GNOME=$([[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && echo true || echo false)
    export DEVSTRAP_GNOME_CUSTOMIZE=$(${DEVSTRAP_USING_GNOME} && ${DEVSTRAP_GUM} confirm "Apply GNOME theme & customizations (including extensions)?" && echo 'y')

    if [ "$DEVSTRAP_USING_GNOME" = true ]; then
        # Ensure computer doesn't go to sleep or lock while installing
        gsettings set org.gnome.desktop.screensaver lock-enabled false
        gsettings set org.gnome.desktop.session idle-delay 0
    fi

    # Update & upgrade packages before installing anything
    ${DEVSTRAP_GUM} spin --title "Updating package dbs..." -- sudo apt-get update > /dev/null
    ${DEVSTRAP_GUM} spin --title "Applying pending upgrades..." -- sudo apt-get upgrade -y > /dev/null

    # Run installers
    for installer in ${DEVSTRAP_PATH}/install.d/*.sh; do
        . $installer
    done

    if [ "$DEVSTRAP_USING_GNOME" = true ]; then
        # Revert to normal idle and lock settings
        gsettings set org.gnome.desktop.screensaver lock-enabled true
        gsettings set org.gnome.desktop.session idle-delay 300
    fi
fi

echo "=> Removing artifacts..."
rm -f ${DEVSTRAP_GUM}
rm -fr ${DEVSTRAP_PATH}

unset DEVSTRAP_GNOME_CUSTOMIZE
unset DEVSTRAP_SELECTED_LANGS
unset DEVSTRAP_USER_EMAIL
unset DEVSTRAP_USERNAME
unset DEVSTRAP_GUM
unset DEVSTRAP_PATH
unset DEVSTRAP_TMP

echo "=> All done!"
