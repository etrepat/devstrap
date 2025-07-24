#!/usr/bin/env bash

# Exit inmediately
set -e

# Reset sudo credentials
sudo -k

# Setup
export DEVSTRAP_TMP="${DEVSTRAP_TMP:-/tmp}"
export DEVSTRAP_PATH="${DEVSTRAP_PATH:-${DEVSTRAP_TMP}/devstrap}"

# Bootstrap required tooling
clear; echo "=> Initializing..."
for req in ${DEVSTRAP_PATH}/requirements.d/*.sh; do . $req; done

# Installation
if gum confirm "This script will bootstrap a freshly installed machine w/several configuration choices. Proceed?"; then
    # Ask for password preemtively
    sudo -l > /dev/null

    # Identify user (for git config)
    export DEVSTRAP_USERNAME=$(gum input --placeholder "Enter full name" --prompt "Name> ")
    export DEVSTRAP_USER_EMAIL=$(gum input --placeholder "Enter email address" --prompt "Email> ")

    # Ask the user to select which programming languages to install
    DEVSTRAP_AVAILABLE_LANGS=("Elixir" "Go" "Java" "Node.js" "PHP" "Python" "Ruby" "Rust")
    DEVSTRAP_DEFAULT_LANGS="Node.js","PHP"
    export DEVSTRAP_SELECTED_LANGS=$(gum choose "${DEVSTRAP_AVAILABLE_LANGS[@]}" --no-limit --selected "${DEVSTRAP_DEFAULT_LANGS}" --height 10 --header "Please, select the programming languages to install")

    # Ask the user it it wants to apply GNOME settings & customizations (if using gnome) ?
    DEVSTRAP_USING_GNOME=$([[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* ]] && echo true || echo false)
    export DEVSTRAP_GNOME_CUSTOMIZE=$(${DEVSTRAP_USING_GNOME} && gum confirm "Apply GNOME theme & customizations (including plugins)?" && echo 'y')

    # Update & upgrade packages before installing anything
    gum spin --title "Upgrading base system (if needed)..." -- yay -Syu > /dev/null

    # Run installers
    for installer in ${DEVSTRAP_PATH}/install.d/*.sh; do
        . $installer
    done
fi

echo "=> Removing artifacts..."
rm -fr ${DEVSTRAP_PATH}

unset DEVSTRAP_GNOME_CUSTOMIZE
unset DEVSTRAP_SELECTED_LANGS
unset DEVSTRAP_USER_EMAIL
unset DEVSTRAP_USERNAME
unset DEVSTRAP_PATH
unset DEVSTRAP_TMP

echo "=> Doing cleanup..."
yay -Rns --noconfirm $(yay -Qdtq)
yay -Sc --noconfirm
yay -Syu --noconfirm

echo "=> All done!"
