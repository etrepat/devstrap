# Use starship.rs for prompt support

m "Installing Starship.rs..."

if ! command -v starship &> /dev/null; then
    cd ${DEVSTRAP_TMP}

    STARSHIP_VERSION=$(curl -s "https://api.github.com/repos/starship/starship/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -sSLo starship.tar.gz "https://github.com/starship/starship/releases/download/v${STARSHIP_VERSION}/starship-x86_64-unknown-linux-musl.tar.gz"

    tar -xf starship.tar.gz starship

    mkdir -p ~/.local/bin
    cp -f starship ~/.local/bin
    rm -f starship starship.tar.gz

    cd -
else
    m "It seems that Starship.rs is already present in the system..."
fi

m "Bootstraping Starship.rs config..."
mkdir -p ~/.config
[ -f "~/.config/starship.toml" ] && mv ~/.config/starship.toml ~/.config/starship.toml.bak
cp -f "${DEVSTRAP_PATH}/config/starship.toml" ~/.config/starship.toml
