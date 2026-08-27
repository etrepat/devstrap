#!/usr/bin/env bash

# Zed (if selected)
devstrap_prompt_editors
if ! devstrap_editor_selected "Zed"; then
    return 0
fi

echo "=> Install Zed..."
yay -S --noconfirm --needed zed

echo "=> Copying base config..."
mkdir -p ~/.config/zed
[ -f "$HOME/.config/zed/settings.json" ] && mv ~/.config/zed/settings.json ~/.config/zed/settings.json.bak
cp -f "${DEVSTRAP_PATH}/config/zed/settings.json" ~/.config/zed/settings.json

# Enable language extensions for the selected languages.
# Zed installs these on next launch (auto_install_extensions); most LSP servers are built-in.
echo "=> Enabling language extensions..."
z="$(cat ~/.config/zed/settings.json)"
if devstrap_lang_selected "PHP"; then
    z="$(jq '.auto_install_extensions.php = true' <<<"${z}")"
fi
if devstrap_lang_selected "Ruby"; then
    z="$(jq '.auto_install_extensions.ruby = true' <<<"${z}")"
fi
cat >~/.config/zed/settings.json <<<"${z}"
