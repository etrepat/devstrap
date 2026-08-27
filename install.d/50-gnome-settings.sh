#!/usr/bin/env bash

# Skip if not in gnome or mandated by user...
[[ "${DEVSTRAP_GNOME_CUSTOMIZE}" != "y" ]] && return 0

# Set the gnome settings, extensions & hotkeys
echo "=> Configure GNOME settings & installing extensions..."

# Install extensions (via shared helper, see helpers.d/10-gnome-extensions.sh)
ext_install appindicatorsupport@rgcjonas.gmail.com
ext_install dash-to-dock@micxgx.gmail.com
ext_install tactile@lundal.io
ext_install caffeine@patapon.info
ext_install Vitals@CoreCoding.com
ext_install blur-my-shell@aunetx
ext_install space-bar@luchrioh
ext_install AlphabeticalAppGrid@stuarthayhurst

# Compile gsettings schemas (user-local, no sudo required)
mkdir -p ~/.local/share/glib-2.0/schemas
for sdir in ~/.local/share/gnome-shell/extensions/*/schemas; do
    [[ -d "${sdir}" ]] || continue
    cp "${sdir}"/*.gschema.xml ~/.local/share/glib-2.0/schemas/ 2>/dev/null || true
done
glib-compile-schemas ~/.local/share/glib-2.0/schemas/

# Set default terminal application
gsettings set org.gnome.desktop.default-applications.terminal exec 'ghostty'

# Center new windows in the middle of the screen
gsettings set org.gnome.mutter center-new-windows true

# Reveal week numbers in the Gnome calendar
gsettings set org.gnome.desktop.calendar show-weekdate true

# Show all options for input sources
gsettings set org.gnome.desktop.input-sources show-all-sources true

# Make writing a '~' character not require pressing space (for es ISO keyboards)
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'es+deadtilde')]"

# Make nautilus sort by type first by default
gsettings set org.gnome.nautilus.preferences default-sort-order 'type'

# Set favorite apps (editor entries depend on the editor(s) selected at install time)
apps=('com.mitchellh.ghostty.desktop' 'org.gnome.Calendar.desktop' 'org.gnome.Nautilus.desktop' 'firefox.desktop' 'spotify.desktop' 'mpv.desktop')
selected="${DEVSTRAP_SELECTED_EDITORS:-}"
[[ -n "${selected}" && " ${selected} " == *" Visual Studio Code "* ]] && apps+=('code.desktop')
[[ -n "${selected}" && " ${selected} " == *" Zed "* ]] && apps+=('dev.zed.Zed.desktop')
apps+=('localsend.desktop' 'org.keepassxc.KeePassXC.desktop' 'org.gnome.Settings.desktop')
favorite_apps="[$(printf "'%s'," "${apps[@]}")]"
favorite_apps="${favorite_apps%,]}]"
gsettings set org.gnome.shell favorite-apps "${favorite_apps}"

# Configure Dock
gsettings set org.gnome.shell.extensions.dash-to-dock autohide true
gsettings set org.gnome.shell.extensions.dash-to-dock require-pressure-to-show false
gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode DYNAMIC
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48
gsettings set org.gnome.shell.extensions.dash-to-dock hot-keys false

# Use 6 fixed workspaces instead of dynamic mode
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 6

# Configure Tactile
gsettings set org.gnome.shell.extensions.tactile col-0 1
gsettings set org.gnome.shell.extensions.tactile col-1 2
gsettings set org.gnome.shell.extensions.tactile col-2 2
gsettings set org.gnome.shell.extensions.tactile col-3 1
gsettings set org.gnome.shell.extensions.tactile row-0 1
gsettings set org.gnome.shell.extensions.tactile row-1 2
gsettings set org.gnome.shell.extensions.tactile row-2 1
gsettings set org.gnome.shell.extensions.tactile gap-size 16

# Configure Blur My Shell
gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false
gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview pipeline 'pipeline_default'
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0

# Configure Space Bar
gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []"

# Configure AlphabeticalAppGrid
gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'start'

# Keybindings

# Use Super+W to close windows
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>w']"

# Open default browser
gsettings set org.gnome.settings-daemon.plugins.media-keys www "['<Super>b']"

# Home (file manager)
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>f']"

# Control center (settings)
gsettings set org.gnome.settings-daemon.plugins.media-keys control-center "['<Shift><Super>s']"

# Use alt for pinned apps
gsettings set org.gnome.shell.keybindings switch-to-application-1 "['<Alt>1']"
gsettings set org.gnome.shell.keybindings switch-to-application-2 "['<Alt>2']"
gsettings set org.gnome.shell.keybindings switch-to-application-3 "['<Alt>3']"
gsettings set org.gnome.shell.keybindings switch-to-application-4 "['<Alt>4']"
gsettings set org.gnome.shell.keybindings switch-to-application-5 "['<Alt>5']"
gsettings set org.gnome.shell.keybindings switch-to-application-6 "['<Alt>6']"
gsettings set org.gnome.shell.keybindings switch-to-application-7 "['<Alt>7']"
gsettings set org.gnome.shell.keybindings switch-to-application-8 "['<Alt>8']"
gsettings set org.gnome.shell.keybindings switch-to-application-9 "['<Alt>9']"

# Use super for workspaces
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"

# Reserve slots for custom keybindings
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']"

# Set albert launcher to Ctrl+Space
# gsettings set org.gnome.desktop.wm.keybindings switch-input-source "@as []"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Albert'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'albert toggle'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Control>space'

# Set flameshot (with the sh fix for starting under Wayland) on alternate print screen key
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "$HOME/.local/bin/flameshot-capture.sh"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Control>Print'

# Set Ghostty to Super+Return & remove default
# gsettings set org.gnome.settings-daemon.plugins.media-keys terminal "@as []"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Terminal (ghostty)'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'ghostty'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Super>Return'

# Set spotify to Super+M
gsettings set org.gnome.shell.keybindings toggle-message-tray "['<Super>v']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'Spotify'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'spotify'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Super>m'
