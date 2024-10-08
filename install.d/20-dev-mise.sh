# Mise for managing multiple versions of languages
# https://mise.jdx.dev/

echo "=> Installing mise..."
if ! command -v mise &> /dev/null; then
    sudo install -dm 755 /etc/apt/keyrings
    curl -sSL https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1>/dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | \
        sudo tee /etc/apt/sources.list.d/mise.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y mise
else
    echo "=> Seems to be already present, skipping..."
fi
