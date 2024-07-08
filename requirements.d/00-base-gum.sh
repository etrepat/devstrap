# Gum is used as TUI frontend for confirmations, option selection & messaging
# Download an install a suitable version to use from now on...

DEVSTRAP_TMP="${DEVSTRAP_TMP:-/tmp}"
DEVSTRAP_PATH="${DEVSTRAP_PATH:-${DEVSTRAP_TMP}/devstrap}"
DEVSTRAP_GUM="${DEVSTRAP_GUM:-${DEVSTRAP_GUM}/gum}"

if [ ! -f "${DEVSTRAP_GUM}" ]; then
    cd ${DEVSTRAP_TMP}
    curl -sSLo gum.tar.gz "https://github.com/charmbracelet/gum/releases/download/v0.14.1/gum_0.14.1_Linux_x86_64.tar.gz"
    tar -xf gum.tar.gz gum_0.14.1_Linux_x86_64/gum -O > ${DEVSTRAP_GUM}
    chmod +x ${DEVSTRAP_GUM}
    cd -
fi
