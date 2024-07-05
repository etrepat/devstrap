# Install base packages & libraries

echo "=> Installing base packages & libraries..."
sudo apt-get install -y git curl wget zip unzip build-essential pkg-config \
    autoconf bison clang cmake imagemagick sqlite3 libsqlite3-0 libsqlite3-dev \
    postgresql-client redis-tools libpq-dev libssl-dev libreadline-dev \
    zlib1g-dev libyaml-dev libncurses5-dev libffi-dev
