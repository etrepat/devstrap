#!/usr/bin/env bash
# Copy bash config

echo "=> Copying bash settings (~/.bashrc)..."

[ -f "~/.bash_aliases" ] && mv ~/.bash_aliases ~/.bash_aliases.bak
cp -f "${DEVSTRAP_PATH}/config/bash_aliases" ~/.bash_aliases

[ -f "~/.bashrc" ] && mv ~/.bashrc ~/.bashrc.bak
cp -f "${DEVSTRAP_PATH}/config/bashrc" ~/.bashrc

[ -f "~/.inputrc" ] && mv ~/.inputrc ~/.inputrc.bak
cp "${DEVSTRAP_PATH}/config/inputrc" ~/.inputrc
