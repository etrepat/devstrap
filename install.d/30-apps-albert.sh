# Albert launcher
# https://albertlauncher.github.io/

echo "=> Installing Albert launcher..."

UBUNTU_VERSION_ID=$(. /etc/os-release && echo "$VERSION_ID")

# Add gpg key
curl -fsSL "https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_${UBUNTU_VERSION_ID}/Release.key" | \
    gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null

# Add osb repository
echo "deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_${UBUNTU_VERSION_ID}/ /" | \
    sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list > /dev/null

sudo apt-get update
sudo apt-get install -y albert
