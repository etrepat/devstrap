# DevStrap

DevStrap is a bash script to rapidly set up a fresh archlinux GNOME box for development.

## Compatibility

Tested & working with latest Arch ISO installer (July 2025) on x64 architecture.

## Install

Run the script:

    curl -sSf 'https://raw.githubusercontent.com/etrepat/devstrap/archlinux/install.sh' | bash

## What does it do?

This script main purpose is to bootstrap a fresh archlinux GNOME box (right after running archinstall, for example) into 
a nicely fitted development environment. Beware, though, that **strong** assumptions
are made on the tooling and environment setup.

It will mainly install & configure for you:

* Terminal (ghostty)
* Bash w/starship.rs for prompt management along with an *opinionated* config
* Compilers and build tools for several languages: Ruby, Go, Java, PHP, Rust, ...
* System tools like curl, git, xclip, imagemagick ...
* Visual Studio Code w/theme & a bare set of extensions
* Several desktop applications: albert launcher, dropbox, flameshot, Firefox, ...
* SSH public/private key for authentication (if not already present), ...

Please, review the `install.d` directory for the detailed list of utilities installed & configs which will get applied.

## Other versions / OS

* [Ubuntu 24.04 LTS](https://github.com/etrepat/devstrap/tree/ubuntu)

## License

DevStrap is released under the [MIT License](https://opensource.org/licenses/MIT).
