#!/usr/bin/env bash
# Docker

echo "=> Installing Docker Engine..."

# Add Docker's official gpg key
sudo install -m 0755 -d /etc/apt/keyrings
curl -sSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the official repository to apt sources
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Give this user privileged Docker access
sudo usermod -aG docker ${USER}

# Use local logging driver - it's more efficient and uses compression by default.
echo '{"log-driver":"local","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json > /dev/null
