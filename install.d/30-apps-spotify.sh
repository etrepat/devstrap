#!/usr/bin/env bash

# Spotify

echo "=> Installing Spotify for Linux..."
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb [signed-by=/etc/apt/trusted.gpg.d/spotify.gpg] https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list > /dev/null
sudo apt-get update
sudo apt-get install -y spotify-client
