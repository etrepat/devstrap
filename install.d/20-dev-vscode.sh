# Visual Studio Code

m "Install Visual Studio Code..."
cd ${DEVSTRAP_TMP}
curl -sSLo code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt-get install -y ./code.deb
rm -f code.deb
cd -

m "Copying base config..."
mkdir -p ~/.config/Code/User
[ -f "~/.config/Code/User/settings.json" ] && mv ~/.config/Code/User/settings.json ~/.config/Code/User/settings.json.bak
cp -f "${DEVSTRAP_PATH}/config/vscode.json" ~/.config/Code/User/settings.json

# Install default extension set
m "Installing base extensions..."
code --install-extension enkia.tokyo-night
code --install-extension vscode-icons-team.vscode-icons
code --install-extension ms-azuretools.vscode-docker
code --install-extension EditorConfig.EditorConfig
code --install-extension eamodio.gitlens
code --install-extension mikestead.dotenv

# Add lang extensions
m "Installing language extensions..."

# Go
code --install-extension golang.go

# PHP (Intelephense)
code --install-extension bmewburn.vscode-intelephense-client

# Rust analyzer
code --install-extension rust-lang.rust-analyzer
