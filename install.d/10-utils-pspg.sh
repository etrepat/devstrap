#!/usr/bin/env bash

# pspg - Postgres Pager
# https://github.com/okbob/pspg
echo "=> Installing pspg..."
yay -S --noconfirm pspg

[ -f "~/.psqlrc" ] && mv ~/.psqlrc ~/.psqlrc.bak
cp "${DEVSTRAP_PATH}/config/psqlrc" ~/.psqlrc
