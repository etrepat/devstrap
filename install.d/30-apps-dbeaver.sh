#!/usr/bin/env bash

# DBeaver

echo "=> Installing DBeaver..."
cd ${DEVSTRAP_TMP}
curl -sSLO https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
sudo apt-get install -y ./dbeaver-ce_latest_amd64.deb
rm -f dbeaver-ce_latest_amd64.deb
cd -
