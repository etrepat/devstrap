 # Download & install fonts

cd $DEVSTRAP_TMP

$DEVSTRAP_GUM spin --title="Downloading 'Cascadia Code' nerd font..." -- curl -sSLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/CascadiaCode.zip

unzip CascadiaCode.zip -d CascadiaFont
mkdir -p ~/.local/share/fonts
cp CascadiaFont/*.ttf ~/.local/share/fonts
rm -fr CascadiaCode.zip CascadiaFont

fc-cache -r

cd -
