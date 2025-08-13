#!/usr/bin/env bash

# DBeaver Community - Free Universal Database Tool
# We install a custom-made aur package so that it can be self-contained with its own JRE
# see: https://aur.archlinux.org/packages/dbeaver-ce-jre-bin

echo "=> Installing DBeaver..."
yay -S dbeaver-ce-jre-bin
