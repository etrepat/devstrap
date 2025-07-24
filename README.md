# DevStrap

DevStrap is a bash script to rapidly set up a fresh linux box for development.

## Compatibility

Currently there are two supported & tested versions for Ubuntu 24.04 LTS x64 
(Jammy Jellyfish) and Arch Linux x64 (GNOME desktop).

* [Ubuntu 24.04 LTS x64](https://github.com/etrepat/devstrap/tree/ubuntu)
* [Arch Linux (GNOME)](https://github.com/etrepat/devstrap/tree/archlinux)

## Install

### Ubuntu 24.04 LTS x64

Install ubuntu desktop from the ISO & after it completes, open a terminal console and run:

```bash
curl -sSf 'https://raw.githubusercontent.com/etrepat/devstrap/ubuntu/install.sh' | bash
```

### Arch Linux x64 (GNOME desktop)

Grab the latest arch x64 ISO from the official website, run archinstall ensuring you select a desktop profile and GNOME
desktop environment. After the installation completes, open a terminal console and run:

```bash
curl -sSf 'https://raw.githubusercontent.com/etrepat/devstrap/archlinux/install.sh' | bash
```

## What does it do?

This script main purpose is to bootstrap a fresh linux box into a nicely fitted
development environment. Beware, though, that **strong** assumptions
are made on the tooling and environment setup.

It will mainly install & configure for you:

* Terminal (kitty/ghostty)
* Bash w/starship.rs for prompt management along with an *opinionated* config
* Compilers and build tools for several languages: Ruby, Go, Java, PHP, Rust, ...
* System tools like curl, git, xclip, imagemagick ...
* Visual Studio Code w/theme & a bare set of extensions
* Several desktop applications: albert launcher, dropbox, flameshot, Google Chrome / Firefox, ...
* SSH public/private key for authentication (if not already present), ...

Please, review the `install.d` directory for the detailed list of utilities installed & configs which will get applied.

## License

DevStrap is released under the [MIT License](https://opensource.org/licenses/MIT).
