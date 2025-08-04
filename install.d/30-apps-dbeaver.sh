#!/usr/bin/env bash

# DBeaver Community - Free Universal Database Tool
# We install a custom-made aur package (pkgbuild) so that it can be installed
# in a self-contained way, with its own JDK.

echo "=> Installing DBeaver..."

cd ${DEVSTRAP_TMP}/pkg/dbeaver
makepkg -si --noconfirm
cd -
