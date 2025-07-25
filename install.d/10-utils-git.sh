# Set common git aliases

echo "=> Applying some git config..."

[ -f "~/.gitconfig" ] && mv ~/.gitconfig ~/.gitconfig.bak
cp -f "${DEVSTRAP_PATH}/config/gitconfig" ~/.gitconfig

# Set identification from install inputs
if [[ -n "${DEVSTRAP_USERNAME//[[:space:]]/}" ]]; then
  git config --global user.name "$DEVSTRAP_USERNAME"
fi

if [[ -n "${DEVSTRAP_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$DEVSTRAP_USER_EMAIL"
fi

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
