#!/usr/bin/env bash

# Install base packages & libraries
echo "=> Installing base packages & libraries..."
yay -S --needed --noconfirm autoconf base-devel bash-completion bison \
    cmake clang curl git imagemagick man less libffi llvm pkgconf \
    postgresql-libs openssl readline sqlite unzip vim wget whois zip zlib
