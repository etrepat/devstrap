#!/usr/bin/env bash

clear; echo -e "\n\e[36;1mdevstrap\e[0m\n"

echo -e "\e[33;1m~>\e[0m Creating private working directories..."
export DEVSTRAP_TMP="$(mktemp -d "${TMPDIR:-/tmp}/devstrap-tmp.XXXXXX")"
export DEVSTRAP_PATH="$(mktemp -d "${TMPDIR:-/tmp}/devstrap.XXXXXX")"
DEVSTRAP_TMP_DIR="${DEVSTRAP_TMP}"
DEVSTRAP_PATH_DIR="${DEVSTRAP_PATH}"

echo -e "\e[33;1m~>\e[0m Cloning devstrap scripts..."
if ! command -v git &> /dev/null; then sudo pacman -S --noconfirm --needed git > /dev/null; fi
git clone -b archlinux https://github.com/etrepat/devstrap.git "${DEVSTRAP_PATH}" > /dev/null

echo -e "\e[33;1m~>\e[0m Starting install..."
. "${DEVSTRAP_PATH}/devstrap.sh"

echo -e "\e[33;1m~>\e[0m Removing artifacts..."
rm -fr "${DEVSTRAP_PATH_DIR}" "${DEVSTRAP_TMP_DIR}"
