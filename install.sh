#!/usr/bin/env bash

# Pre-declare some variables...
DEVSTRAP_TMP=/tmp
DEVSTRAP_PATH="${DEVSTRAP_TMP}/devstrap"

clear
echo -e "\e[33;1mdevstrap\e[0m"

echo "=> Cloning devstrap installation scripts..."
if ! command -v git &> /dev/null; then sudo pacman -S --noconfirm --needed git > /dev/null; fi
[ -d "${DEVSTRAP_PATH}" ] && rm -fr ${DEVSTRAP_PATH}
git clone -b archlinux https://github.com/etrepat/devstrap.git ${DEVSTRAP_PATH} > /dev/null

echo "=> Starting install..."
. ${DEVSTRAP_PATH}/devstrap.sh
