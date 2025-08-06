#!/usr/bin/env bash

# Flameshot is a nice step-up over the default Gnome screenshot tool
echo "=> Installing Flameshot..."
yay -S --noconfirm --needed flameshot

# Little hack so that it works under Gnome+Wayland
# see: https://flameshot.org/docs/guide/wayland-help/#gnome-shortcut-does-not-trigger-flameshot
mkdir -p ~/.local/bin
cat <<EOF >~/.local/bin/flameshot-capture.sh
#!/usr/bin/env bash
QT_QPA_PLATFORM=wayland /usr/bin/flameshot gui
EOF
chmod ugo+x ~/.local/bin/flameshot-capture.sh
