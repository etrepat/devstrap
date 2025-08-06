#!/usr/bin/env bash

# DBeaver Community - Free Universal Database Tool
# We install a custom-made aur package (pkgbuild) so that it can be installed
# self-contained, with its own JDK.
echo "=> Installing DBeaver..."
cd ${DEVSTRAP_PATH}/pkg/dbeaver
makepkg -si --noconfirm
cd -
