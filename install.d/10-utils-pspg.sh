# pspg - Postgres Pager
# https://github.com/okbob/pspg

m "Installing pspg..."

sudo apt-get install -y pspg

[ -f "~/.psqlrc" ] && mv ~/.psqlrc ~/.psqlrc.bak
cp "${DEVSTRAP_PATH}/config/psqlrc" ~/.psqlrc
