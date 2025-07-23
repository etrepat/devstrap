#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Pre-declare some variables...
DEVSTRAP_TMP=/tmp
DEVSTRAP_PATH="${DEVSTRAP_TMP}/devstrap"

echo -e "\e[33;1mdevstrap\e[0m"

echo "=> Cloning devstrap scripts..."
if ! command -v git &> /dev/null; then sudo pacman -S --noconfirm --needed base-devel git > /dev/null; fi
[ -d "${DEVSTRAP_PATH}" ] && rm -fr ${DEVSTRAP_PATH}
git clone -b archlinux https://github.com/etrepat/devstrap.git ${DEVSTRAP_PATH} > /dev/null

echo "=> Starting install..."
. ${DEVSTRAP_PATH}/devstrap.sh
