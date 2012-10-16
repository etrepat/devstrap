# DevStrap

DevStrap is a simple script to rapidly set up a debian/ubuntu box for Ruby/Rails
development.

## Requirements

A recent fresh debian/ubuntu install.

## Install

Run the script:

    bash < <(curl -s https://raw.github.com/etrepat/devstrap/master/devstrap.sh)

## What does it do?

This script main purpose is to bootstrap a fresh debian/ubuntu box into a nicely
fitted ruby development environment. Beware, though, that **strong** assumptions
are made on the tooling and environment setup.

It will mainly install for you:

* Compiler and build tools
* All *base* dependencies to allow building gems from source without failing (most of)
* Curl
* Git
* SQLite3 client and dev libraries
* PostgreSQL client and dev libraries (yes, you should use postgres on development too)
* Imagemagick for image manipulation client and dev libraries
* Latest stable RVM
* Latest stable patch-level of Ruby (from source)
* Latest bundler on the global gemset
* The `bundler-exec` script so you don't need to type `bundle [command] ...`
every time.
* Some tooling: xclip, tmux, vim, sublime text 2, ...
* Perform some *very minimal* bash config/s: Aliases, paths, ...
* SSH public key for authentication with your staging servers, heroku, github,
bitbucket, ...

---

Assembled by Estanislau Trepat in 2012. Released under the terms of the MIT
license (see LICENSE file).
