#!/usr/bin/env bash
# Install base packages & libraries

echo "=> Installing base packages & libraries..."
yay -S --needed --noconfirm autoconf base-devel bash-completion bat bison btop \
    cmake clang curl eza fastfetch fd fzf git imagemagick jq man less libffi \
    llvm pkgconf postgresql-libs openssl readline ripgrep sqlite tldr unzip \
    wget whois xclip zip zlib

yay -Rns --noconfirm htop
