#!/usr/bin/env bash

# Git config
echo "=> Applying some git config..."
[ -f "$HOME/.gitconfig" ] && mv ~/.gitconfig ~/.gitconfig.bak
cp -f "${DEVSTRAP_PATH}/config/gitconfig" ~/.gitconfig

# Set identification from install inputs
if [[ -n "${DEVSTRAP_USERNAME//[[:space:]]/}" ]]; then
    git config --global user.name "$DEVSTRAP_USERNAME"
fi

if [[ -n "${DEVSTRAP_USER_EMAIL//[[:space:]]/}" ]]; then
    git config --global user.email "$DEVSTRAP_USER_EMAIL"
fi

# git aliases live in config/gitconfig ([alias] section)

echo "=> Installing 'git-delta'..."
yay -S --needed --noconfirm git-delta

# lazygit - simple terminal UI for git commands
# https://github.com/jesseduffield/lazygit
echo "=> Installing 'lazygit'..."
yay -S --needed --noconfirm lazygit

# GitHub & GitLab CLI
echo "=> Installing 'gh' (GitHub CLI) & 'glab' (GitLab CLI)..."
yay -S --needed --noconfirm github-cli glab
