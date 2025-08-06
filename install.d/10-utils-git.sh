#!/usr/bin/env bash

# Git config
echo "=> Applying some git config..."
[ -f "~/.gitconfig" ] && mv ~/.gitconfig ~/.gitconfig.bak
cp -f "${DEVSTRAP_PATH}/config/gitconfig" ~/.gitconfig

# Set identification from install inputs
if [[ -n "${DEVSTRAP_USERNAME//[[:space:]]/}" ]]; then
  git config --global user.name "$DEVSTRAP_USERNAME"
fi

if [[ -n "${DEVSTRAP_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$DEVSTRAP_USER_EMAIL"
fi

# Set common git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

# lazygit - simple terminal UI for git commands
# https://github.com/jesseduffield/lazygit
echo "=> Installing 'lazygit'..."
yay -S --needed --noconfirm lazygit
