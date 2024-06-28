# Keepassxc - My password manager of choice
# https://keepassxc.org/

m "Intalling KeePassXC..."

# Add repository
sudo add-apt-repository -y ppa:phoerious/keepassxc
sudo apt-get update

# Install
sudo apt-get install -y keepassxc
