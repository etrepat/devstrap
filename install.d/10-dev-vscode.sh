# Visual Studio Code

cd ${DEVSTRAP_TMP}
curl -sSLo code.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'
sudo apt-get install -y ./code.deb
rm -f code.deb
cd -

mkdir -p ~/.config/Code/User
cp -f "${DEVSTRAP_PATH}/config/vscode.json" ~/.config/Code/User/settings.json

# Install default extension set
code --install-extension enkia.tokyo-night
code --install-extension vscode-icons-team.vscode-icons
code --install-extension ms-azuretools.vscode-docker
code --install-extension EditorConfig.EditorConfig
code --install-extension eamodio.gitlens
code --install-extension mikestead.dotenv

# Add lang extensions

# Go
code --install-extension golang.go

# PHP (Intelephense)
code --install-extension bmewburn.vscode-intelephense-client

# Rust analyzer
code --install-extension rust-lang.rust-analyzer
