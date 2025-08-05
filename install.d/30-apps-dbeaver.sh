#!/usr/bin/env bash

# DBeaver Community - Free Universal Database Tool
# We install a custom-made aur package (pkgbuild) so that it can be installed
# in a self-contained way, with its own JDK.

# FIXME
# This is to install a fully self-contained dbeaver version so that Java is included and can coexist with anything
# installed by the user. We should think about removing this script and use an AUR package instead or provide a PKGBUILD.

echo "=> Installing DBeaver..."

cd ${DEVSTRAP_PATH}/pkg/dbeaver
makepkg -si --noconfirm
cd -
