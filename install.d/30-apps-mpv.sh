#!/usr/bin/env bash

# mpv - a free, open source, and cross-platform media player
# https://mpv.io/
echo "=> Installing mpv..."

yay -S --noconfirm --needed mpv mpv-mpris

cp -r /usr/share/doc/mpv/ ~/.config/
sed -i 's/#profile=high-quality/profile=high-quality/' ~/.config/mpv/mpv.conf
sed -i 's/#hwdec=auto/hwdec=auto/' ~/.config/mpv/mpv.conf
