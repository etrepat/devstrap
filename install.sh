#!/usr/bin/env bash

DEVSTRAP_TMP=/tmp
DEVSTRAP_PATH="${DEVSTRAP_TMP}/devstrap"

if ! command -v git &> /dev/null; then
    echo "Installing git..."
    sudo apt install -y git > /dev/null
fi

echo "Cloning devstrap scripts..."

if [ -d ${DEVSTRAP_PATH} ]; then
    rm -fr ${DEVSTRAP_PATH}
fi

git clone -b main https://github.com/etrepat/devstrap.git ${DEVSTRAP_PATH} > /dev/null

. ${DEVSTRAP_PATH}/devstrap.sh
