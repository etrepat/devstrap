# Google Chrome

cd /tmp
curl -sSLO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt-get install -y ./google-chrome-stable_current_amd64.deb
rm -f google-chrome-stable_current_amd64.deb
# xdg-settings set default-web-browser google-chrome.desktop
cd -
