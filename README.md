# DevStrap

DevStrap is a bash script to rapidly set up a fresh ubuntu box for development.

## Compatibility

Tested & working with latest Ubuntu 24.04 LTS x64 (Jammy Jellyfish).

## Install

Run the script:

    bash < <(wget -qO- https://raw.github.com/etrepat/devstrap/main/install.sh)

## What does it do?

This script main purpose is to bootstrap a fresh ubuntu box into a nicely fitted
development environment. Beware, though, that **strong** assumptions
are made on the tooling and environment setup.

It will mainly install & configure for you:

* Terminal (kitty)
* Bash w/starship.rs for prompt management along with an *opinionated* config
* Compilers and build tools for several languages: Ruby, Go, Java, PHP, Rust, ...
* System tools like curl, git, xclip, imagemagick ...
* Visual Studio Code w/theme & a bare set of extensions
* Several desktop applications: albert launcher, dropbox, flameshot, Google Chrome, ...
* SSH public/private key for authentication (if not already present), ...

Please, review the `install.d` directory for the detailed list of utilities installed & configs which will get applied.

## License

DevStrap is released under the [MIT License](https://opensource.org/licenses/MIT).
