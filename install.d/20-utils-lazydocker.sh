# lazydocker -  The lazier way to manage everything docker
# https://github.com/jesseduffield/lazydocker

m "Installing 'lazydocker'..."
cd $DEVSTRAP_TMP
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -sSLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
tar -xf lazydocker.tar.gz lazydocker
sudo install lazydocker /usr/local/bin
rm -f lazydocker.tar.gz lazydocker
cd -
