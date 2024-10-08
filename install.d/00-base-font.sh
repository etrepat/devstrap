 # Download & install fonts

echo "=> Installing 'CaskaydiaCove Nerd Font'..."
if ! $(fc-list | grep -i "CaskaydiaCove" > /dev/null); then
    cd ${DEVSTRAP_TMP}

    curl -fsSLO 'https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip'
    unzip CascadiaCode.zip -d CascadiaFont
    mkdir -p ~/.local/share/fonts
    cp CascadiaFont/*.ttf ~/.local/share/fonts
    rm -fr CascadiaCode.zip CascadiaFont

    cd -

    fc-cache -r
else
    echo "=> Font already exists in the system... Skipping..."
fi
