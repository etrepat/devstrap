#!/usr/bin/env bash

# Add printing services
yay -S --noconfirm avahi cups cups-pdf cups-filters
sudo systemctl enable --now avahi-daemon.service
sudo systemctl enable --now cups.service
