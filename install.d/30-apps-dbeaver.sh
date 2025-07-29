#!/usr/bin/env bash
# DBeaver Community - Free Universal Database Tool

# FIXME
# This is to install a fully self-contained dbeaver version so that Java is included and can coexist with anything
# installed by the user. We should think about removing this script and use an AUR package instead or provide a PKGBUILD.

echo "=> Installing DBeaver..."

cd ${DEVSTRAP_TMP}
curl -sSLo dbeaver.tar.gz "https://dbeaver.io/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz"

tar -xf dbeaver.tar.gz dbeaver
sudo mv ${DEVSTRAP_TMP}/dbeaver /opt/dbeaver
sudo cp -f /opt/dbeaver/dbeaver.png /usr/share/pixmaps/dbeaver.png

# Add desktop entry
cat <<EOF >~/.local/share/applications/dbeaver-ce.desktop
[Desktop Entry]
Name=DBeaver Community Edition
Type=Application
Comment=Free Universal Database Tool
Path=/opt/dbeaver/
Exec=/opt/dbeaver/dbeaver
Icon=/opt/dbeaver/dbeaver.png
Categories=Database;Development;
Keywords=dbeaver;database;sql;development;
StartupNotify=true
StartupWMClass=DBeaver
Terminal=false
X-GNOME-UsesNotifications=true
EOF

update-desktop-database ~/.local/share/applications
cd -
