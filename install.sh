#!/usr/bin/env bash

error_exit() {
    echo -e "\e[31;1mError:\e[0m $1"
    exit 1
}

# Say something
clear; echo -e "\n\e[36;1mdevstrap\e[0m\n"

# Pre-declare some variables...
DEVSTRAP_TMP=/tmp
DEVSTRAP_PATH="${DEVSTRAP_TMP}/devstrap"

# Check arch & load os-release file
ARCH=$(uname -m)
[[ ! "$ARCH" =~ ^(x86_64|i686)$ ]] && error_exit "Unsupported architecture: $ARCH. Only x86_64/i686 are supported."
[ ! -f /etc/os-release ] && error_exit "Unable to determine OS. /etc/os-release file not found !?"
. /etc/os-release

# Clone proper distro script
echo -e "\e[33;1m~>\e[0m Cloning devstrap scripts..."
[ -d "${DEVSTRAP_PATH}" ] && rm -fr ${DEVSTRAP_PATH}

case "$ID" in
    ubuntu)
        [ $(echo "$VERSION_ID >= 24.04" | bc) != 1 ] && error_exit "Unsupported OS: $ID $VERSION_ID. Ubuntu 24.04+ is required."
        if ! command -v git &> /dev/null; then sudo apt-get install -y git > /dev/null; fi
        git clone -b ubuntu https://github.com/etrepat/devstrap.git ${DEVSTRAP_PATH} > /dev/null
        ;;
    arch)
        if ! command -v git &> /dev/null; then sudo pacman -S --noconfirm --needed git > /dev/null; fi
        git clone -b archlinux https://github.com/etrepat/devstrap.git ${DEVSTRAP_PATH} > /dev/null
        ;;
    manjaro)
        if ! command -v git &> /dev/null; then sudo pacman -S --noconfirm --needed git > /dev/null; fi
        git clone -b manjaro https://github.com/etrepat/devstrap.git ${DEVSTRAP_PATH} > /dev/null
        ;;
    *)
        error_exit "Unsupported OS: $ID $VERSION_ID. Only Ubuntu 24.04+, Arch Linux and Manjaro are supported."
        ;;
esac

echo -e "\e[33;1m~>\e[0m Starting install..."
. ${DEVSTRAP_PATH}/devstrap.sh
