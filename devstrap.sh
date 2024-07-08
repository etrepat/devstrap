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

    # Select dev languages to install
    DEVSTRAP_AVAILABLE_LANGS=("Elixir" "Go" "Java" "Node.js" "PHP" "Python" "Ruby" "Rust")
    DEVSTRAP_DEFAULT_LANGS="Node.js","PHP"
    DEVSTRAP_SELECTED_LANGS=$(${DEVSTRAP_GUM} choose "${DEVSTRAP_AVAILABLE_LANGS[@]}" --no-limit --selected "${DEVSTRAP_DEFAULT_LANGS}" --height 10 --header "Please, select the programming languages to install")

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
