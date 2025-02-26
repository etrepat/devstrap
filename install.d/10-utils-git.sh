# Set common git aliases

echo "=> Applying some git config..."

[ -f "~/.gitconfig" ] && mv ~/.gitconfig ~/.gitconfig.bak
cp -f "${DEVSTRAP_PATH}/config/gitconfig" ~/.gitconfig

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
