#!/bin/bash

# Install & set power-profiles daemon as it is an optional dependency
yay -S --noconfirm power-profiles-daemon

if ls /sys/class/power_supply/BAT* &>/dev/null; then
  # This computer runs on a battery
  powerprofilesctl set balanced || true
else
  # This computer runs on power outlet
  powerprofilesctl set performance || true
fi
