# localsend - Share files to nearby devices.
# https://localsend.org/

m "Installing LocalSend..."
cd ${DEVSTRAP_TMP}
LOCALSEND_VERSION=$(curl -s "https://api.github.com/repos/localsend/localsend/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -sSLo localsend.deb "https://github.com/localsend/localsend/releases/latest/download/LocalSend-${LOCALSEND_VERSION}-linux-x86-64.deb"
sudo apt-get install -y ./localsend.deb
rm -f localsend.deb
cd -
