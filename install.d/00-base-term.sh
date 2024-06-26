# Terminal
# These days I like to use kitty as a terminal with a modern feature set...
#
# kitty - The fast, feature-rich, GPU based terminal emulator
# https://sw.kovidgoyal.net/kitty/

m "Installing terminal application (kitty)..."
curl -sSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin \
    launch=n

m "Bootstrapping kitty config..."

# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
#echo 'kitty.desktop' > ~/.config/xdg-terminals.list

mkdir -p ~/.config/kitty
cp -f "${DEVSTRAP_PATH}/config/kitty.conf ~/.config/kitty/kitty.conf
cp -f "${DEVSTRAP_PATH}/config/kitty/theme.conf ~/.config/kitty/theme.conf