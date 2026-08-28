#!/usr/bin/env bash

# Voxtype - push-to-talk voice-to-text, local & Wayland-first
# https://voxtype.io/
echo "=> Installing Voxtype..."
yay -S --noconfirm --needed voxtype-bin wtype libnotify gtk4-layer-shell

# Built-in evdev hotkey detection requires the 'input' group (GNOME/KDE path)
if ! groups "$USER" | grep -qw input; then
    sudo usermod -aG input "$USER"
    echo "  (added '$USER' to the 'input' group — log out and back in for the hotkey to work)"
fi

echo "=> Bootstraping Voxtype config from /etc/voxtype/config.toml..."
mkdir -p ~/.config/voxtype
[ -f "$HOME/.config/voxtype/config.toml" ] && mv ~/.config/voxtype/config.toml ~/.config/voxtype/config.toml.bak
cp -f /etc/voxtype/config.toml ~/.config/voxtype/config.toml

# Enable the built-in evdev hotkey (we added the user to the 'input' group above)
sed -i 's/^enabled = false/enabled = true/' ~/.config/voxtype/config.toml

# Whisper multilingual model + constrained English/Spanish/Catalan auto-detect
sed -i 's/^model = "base.en"/model = "small"/' ~/.config/voxtype/config.toml
sed -i 's/^language = "en"/language = ["en", "es", "ca"]/' ~/.config/voxtype/config.toml

# Change the model modifier key
sed -i 's/^# model_modifier = "LEFTSHIFT"/model_modifier = "RIGHTSHIFT"/' ~/.config/voxtype/config.toml

echo "=> Downloading Whisper 'small' multilingual model..."
# NOTE: `--model` misroutes the name to the SenseVoice ?? and fails with
# "SenseVoice feature not enabled". The configured model in config.toml ("small")
# is used automatically by plain `--download`, so we rely on that instead.
voxtype setup --download --no-post-install

echo "=> Installing & starting Voxtype daemon (auto-starts on login)..."
voxtype setup systemd
systemctl --user enable --now voxtype
