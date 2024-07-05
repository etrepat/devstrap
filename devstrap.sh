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
for req in ${DEVSTRAP_PATH}/req.d/*.sh; do . $req; done

# Installation
m "This script will bootstrap a freshly installed machine w/several configuration choices."

read -p "Proceed? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Ask for password preemtively
    sudo -l > /dev/null

    # Update packages before installing anything
    echo "=> Updating package dbs & applying upgrades (if any)..."
    sudo apt-get update && sudo apt-get upgrade -y

    # Run installers
    for installer in ${DEVSTRAP_PATH}/install.d/*.sh; do
        . $installer
    done

    # Update packages after installing everything
    echo "=> Updating package dbs & applying upgrades (if any)..."
    sudo apt-get update && sudo apt-get upgrade -y
fi

echo "=> Removing artifacts..."
rm -f ${DEVSTRAP_GUM}
rm -fr ${DEVSTRAP_PATH}

echo "=> All done!"
