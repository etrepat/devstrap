# Install base packages & libraries
$DEVSTRAP_GUM spin --show-error --title="Installing base packages & libraries..." -- sudo apt-get install -y \
    git curl wget zip unzip \
    build-essential pkg-config autoconf bison \
    libssl-dev libreadline-dev zlib1g-dev libyaml-dev libreadline-dev libncurses5-dev libffi-dev
