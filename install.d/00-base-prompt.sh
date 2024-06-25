# Use starship.rs for prompt support

cd $DEVSTRAP_TMP

STARSHIP_VERSION=$(curl -s "https://api.github.com/repos/starship/starship/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -sSLo starship.tar.gz "https://github.com/starship/starship/releases/download/${STARSHIP_VERSION}/starship-x86_64-unknown-linux-musl.tar.gz"
tar -xf starship.tar.gz starship

mkdir -p ~/.local/bin
cp -f starship ~/.local/bin
rm -f starship starship.tar.gz

cd -

mkdir -p ~/.config
cp -f $DEVSTRAP_PATH/config/starship.toml ~/.config/starship.toml
