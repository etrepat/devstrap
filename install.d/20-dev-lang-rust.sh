# Rust

echo "=> Installing Rust..."

cd ${DEVSTRAP_TMP}
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cd -
