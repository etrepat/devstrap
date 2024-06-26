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

if ! command -v curl &> /dev/null; then sudo apt-get install -y curl > /dev/null; fi

# Installation
m "This script will bootstrap a freshly installed machine w/several configuration choices."

read -p "Proceed? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Ask for password preemtively
    sudo -l > /dev/null

    # Update packages before installing anything
    m "Updating package dbs & applying upgrades (if any)..."
    sudo apt-get update && sudo apt-get upgrade -y

    # Run installers
    for installer in ${DEVSTRAP_PATH}/install.d/*.sh; do
        . $installer
    done

    # Update packages after installing everything
    m "Updating package dbs & applying upgrades (if any)..."
    sudo apt-get update && sudo apt-get upgrade -y
fi

m "Removing artifacts..."
rm -fr ${DEVSTRAP_PATH}

m "All done!"
