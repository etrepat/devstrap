#!/usr/bin/env bash
# Add printing services

yay -S --noconfirm cups cups-pdf cups-filters
sudo systemctl enable --now cups.service
