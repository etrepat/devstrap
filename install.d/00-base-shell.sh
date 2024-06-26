# Copy bash config

m "Copying bash settings (~/.bashrc)..."

[ -f "~/.bash_aliases" ] && mv ~/.bash_aliases ~/.bash_aliases.bak
cp -f "${DEVSTRAP_PATH}/config/bash_aliases" ~/.bash_aliases

[ -f "~/.bashrc" ] && mv ~/.bashrc ~/.bashrc.bak
cp -f "${DEVSTRAP_PATH}/config/bashrc" ~/.bashrc
