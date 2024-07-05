#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

DEVSTRAP_TMP=/tmp
DEVSTRAP_PATH="${DEVSTRAP_TMP}/devstrap"
DEVSTRAP_GUM="${DEVSTRAP_GUM:-${DEVSTRAP_GUM}/gum}"

if ! command -v git &> /dev/null; then sudo apt-get install -y git > /dev/null; fi

echo "=> Cloning devstrap scripts..."
[ -d "${DEVSTRAP_PATH}" ] && rm -fr ${DEVSTRAP_PATH}
git clone -b main https://github.com/etrepat/devstrap.git ${DEVSTRAP_PATH} > /dev/null

. ${DEVSTRAP_PATH}/devstrap.sh
