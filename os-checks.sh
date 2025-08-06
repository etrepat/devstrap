#!/usr/bin/env bash

error_exit() {
    echo -e "\e[31;1mError:\e[0m $1"
    exit 1
}

# Check architecture (x86 only)
ARCH=$(uname -m)
[[ ! "$ARCH" =~ ^(x86_64|i686)$ ]] && error_exit "Unsupported architecture: $ARCH. Only x86_64/i686 are supported."

[ ! -f /etc/os-release ] && error_exit "Unable to determine OS. /etc/os-release file not found !?"
. /etc/os-release

# Check for Archlinux
[ "$ID" != "arch" ] && error_exit "Unsupported OS: $ID $VERSION_ID."
