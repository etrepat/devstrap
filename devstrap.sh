#!/usr/bin/env bash

set -e
sudo -k

# Utility functions

m() { echo -e "\e[1;33m~>\e[0m $*"; }

# Setup

DEVSTRAP_TMP="${DEVSTRAP_TMP:-/tmp}"
DEVSTRAP_PATH="${DEVSTRAP_PATH:-${DEVSTRAP_TMP}/devstrap}"

clear; m "Initializing..."

# Bootstrap tooling

if ! command -v git &> /dev/null; then sudo apt-get install -y curl > /dev/null; fi

DEVSTRAP_GUM="${DEVSTRAP_TMP}/gum"

if [ ! -f "${DEVSTRAP_GUM}" ]; then
    GUM_PACKAGE_NAME="gum_0.14.1_Linux_x86_64"
    curl -sSLo "${DEVSTRAP_TMP}/${GUM_PACKAGE_NAME}.tar.gz" "https://github.com/charmbracelet/gum/releases/latest/download/${GUM_PACKAGE_NAME}.tar.gz"
    tar -xf "${DEVSTRAP_TMP}/${GUM_PACKAGE_NAME}.tar.gz" -C "${DEVSTRAP_TMP}"
    cp -f ${DEVSTRAP_TMP}/${GUM_PACKAGE_NAME}/gum ${DEVSTRAP_GUM}
    rm -fr ${GUM_PACKAGE_NAME}
fi

# Installation

if $DEVSTRAP_GUM confirm "This script will bootstrap a freshly installed machine w/several configuration choices. Proceed?"; then
    # Ask for password preemtively
    sudo -l > /dev/null

    # Update packages before installing anything
    $DEVSTRAP_GUM spin --show-error --title="Updating base system..." -- sudo apt-get update -y && sudo apt-get upgrade -y

    # Run installers
    for installer in ${DEVSTRAP_PATH}/install/*.sh; do
        . $installer
    done

    # Update packages after installing everything
    $DEVSTRAP_GUM spin --show-error --title="Aplying any missing updates..." -- sudo apt-get update -y && sudo apt-get upgrade -y
fi

m "Removing artifacts..."
rm -fr ${DEVSTRAP_GUM} ${DEVSTRAP_PATH}

m "All done!"
