#!/usr/bin/env bash
# Install base packages & libraries

echo "=> Installing base packages & libraries..."

yay -S --needed --noconfirm autoconf base-devel bison cmake clang curl git \
    imagemagick man less libffi llvm pkgconf postgresql-libs openssl readline \
    sqlite unzip wget whois xclip zip zlib
