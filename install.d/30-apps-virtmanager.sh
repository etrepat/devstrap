#!/usr/bin/env bash

# Install QEMU & VirtManager
echo "=> Installing QEMU/Virt Manager..."
yay -S --noconfirm --needed qemu-desktop libvirt virt-manager
sudo systemctl enable libvirtd.service
sudo usermod -aG libvirt ${USER}
