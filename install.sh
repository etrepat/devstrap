#!/usr/bin/env bash

# Pre-declare some variables...
DEVSTRAP_TMP=/tmp
DEVSTRAP_PATH="${DEVSTRAP_TMP}/devstrap"

clear; echo -e "\n\e[36;1mdevstrap\e[0m\n"

echo -e "\e[33;1m~>\e[0m Cloning devstrap installation scripts..."
if ! command -v git &> /dev/null; then sudo pacman -S --noconfirm --needed git > /dev/null; fi
[ -d "${DEVSTRAP_PATH}" ] && rm -fr ${DEVSTRAP_PATH}
git clone -b manjaro https://github.com/etrepat/devstrap.git ${DEVSTRAP_PATH} > /dev/null

echo -e "\e[33;1m~>\e[0m Starting install..."
. ${DEVSTRAP_PATH}/devstrap.sh
