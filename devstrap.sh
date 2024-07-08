#!/usr/bin/env bash

# Exit inmediately
set -e

# Reset sudo credentials
sudo -k

# Setup
DEVSTRAP_TMP="${DEVSTRAP_TMP:-/tmp}"
DEVSTRAP_PATH="${DEVSTRAP_PATH:-${DEVSTRAP_TMP}/devstrap}"
DEVSTRAP_GUM="${DEVSTRAP_GUM:-${DEVSTRAP_TMP}/gum}"

# Bootstrap required tooling
clear; echo "=> Initializing..."
for req in ${DEVSTRAP_PATH}/requirements.d/*.sh; do . $req; done

# Installation
if ${DEVSTRAP_GUM} confirm "This script will bootstrap a freshly installed machine w/several configuration choices. Proceed?"; then
    # Ask for password preemtively
    sudo -l > /dev/null

    # Ask the user to select which programming languages to install
    DEVSTRAP_AVAILABLE_LANGS=("Elixir" "Go" "Java" "Node.js" "PHP" "Python" "Ruby" "Rust")
    DEVSTRAP_DEFAULT_LANGS="Node.js","PHP"
    DEVSTRAP_SELECTED_LANGS=$(${DEVSTRAP_GUM} choose "${DEVSTRAP_AVAILABLE_LANGS[@]}" --no-limit --selected "${DEVSTRAP_DEFAULT_LANGS}" --height 10 --header "Please, select the programming languages to install")

    # Ask the user it it wants to apply GNOME settings & customizations (if using gnome) ?
    DEVSTRAP_USING_GNOME=$([[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && echo true || echo false)
    DEVSTRAP_GNOME_CUSTOMIZE=$(${DEVSTRAP_USING_GNOME} && ${DEVSTRAP_GUM} confirm "Apply GNOME theme & customizations (including plugins)?" && echo 'y')

    # Update & upgrade packages before installing anything
    ${DEVSTRAP_GUM} spin --title "Updating package dbs..." -- sudo apt-get update > /dev/null
    ${DEVSTRAP_GUM} spin --title "Applying pending upgrades..." -- sudo apt-get upgrade -y > /dev/null

    # Run installers
    for installer in ${DEVSTRAP_PATH}/install.d/*.sh; do
        . $installer
    done
fi

echo "=> Removing artifacts..."
rm -f ${DEVSTRAP_GUM}
rm -fr ${DEVSTRAP_PATH}

echo "=> All done!"
