#!/usr/bin/env bash

# ufw firewall with sane defaults
echo "=> Installing ufw..."
yay -S --noconfirm --needed ufw

# Sane defaults: deny all incoming, allow all outgoing
sudo ufw default deny incoming
sudo ufw default allow outgoing

# LocalSend (nearby device file sharing) - TCP + UDP discovery port
sudo ufw allow 53317/tcp comment 'LocalSend'
sudo ufw allow 53317/udp comment 'LocalSend discovery'

# Enable & start the firewall
sudo systemctl enable ufw
sudo ufw --force enable