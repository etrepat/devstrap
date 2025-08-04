#!/usr/bin/env bash

# Curl

if ! command -v curl &> /dev/null; then
    sudo apt-get install -y curl > /dev/null
fi
