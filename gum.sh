# Gum tool installer
if ! command -v gum &> /dev/null; then
    cd /tmp

    GUM_VERSION=$(curl -s "https://api.github.com/repos/charmbracelet/gum/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    GUM_PACKAGE_NAME="gum_${GUM_VERSION}_Linux_x86_64"
    GUM_ARCHIVE_NAME="${GUM_PACKAGE_NAME}.tar.gz"

    curl -sLo $GUM_ARCHIVE_NAME "https://github.com/charmbracelet/gum/releases/latest/download/${GUM_ARCHIVE_NAME}"
    tar -xf $GUM_ARCHIVE_NAME
    sudo install $GUM_PACKAGE_NAME/gum /usr/local/bin

    rm -fr $GUM_PACKAGE_NAME
    rm -f $GUM_ARCHIVE_NAME
fi
