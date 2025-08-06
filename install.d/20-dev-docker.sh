#!/usr/bin/env bash

# Docker
echo "=> Installing Docker Engine..."
yay -S --noconfirm --needed docker docker-compose docker-buildx

sudo mkdir -p /etc/docker
# Use local logging driver - it's more efficient and uses compression by default.
echo '{"log-driver":"local","log-opts":{"max-size":"10m","max-file":"5"}}' | sudo tee /etc/docker/daemon.json > /dev/null

# Give this user privileged Docker access
sudo usermod -aG docker ${USER}

# Start Docker automatically
sudo systemctl enable docker

# # Prevent Docker from preventing boot for network-online.target
# sudo mkdir -p /etc/systemd/system/docker.service.d
# sudo tee /etc/systemd/system/docker.service.d/no-block-boot.conf <<'EOF'
# [Unit]
# DefaultDependencies=no
# EOF

sudo systemctl daemon-reload

# lazydocker - simple terminal UI for docker commands
# https://github.com/jesseduffield/lazydocker
echo "=> Installing 'lazydocker'..."
yay -S --noconfirm lazydocker-bin
