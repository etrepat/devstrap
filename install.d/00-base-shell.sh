# Copy bash config

[ -f "~/.bashrc" ] && mv ~/.bashrc ~/.bashrc.bak
cp $DEVSTRAP_PATH/config/bashrc ~/.bashrc
