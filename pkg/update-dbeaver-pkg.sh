#!/usr/bin/env bash

set -euo pipefail

PKGBUILD="PKGBUILD"

cd dbeaver

# Get latest version from GitHub
echo "Fetching latest dbeaver release..."
LATEST_VER=$(curl -sI https://github.com/dbeaver/dbeaver/releases/latest \
    | grep -i '^location:' \
    | sed -E 's#.*/tag/v?##; s#\r##')

echo "Latest version: $LATEST_VER"

# Update PKGBUILD pkgver and source URL
echo "Updating PKGBUILD..."
sed -i -E "s/^pkgver=.*/pkgver=$LATEST_VER/" "$PKGBUILD"

# Update sha256sums
echo "Updating sha256sums..."
NEW_SHA_LINE=$(makepkg -g 2>/dev/null | grep sha256sums)
sed -i -E "s/^sha256sums=.*/$NEW_SHA_LINE/" "$PKGBUILD"

# Regenerate .SRCINFO
echo "Regenerating .SRCINFO..."
makepkg --printsrcinfo > .SRCINFO

# Clean up
rm -fr src/
rm -f "dbeaver-ce-${LATEST_VER}-linux.gtk.x86_64.tar.gz"

cd -
echo "✅ Updated to $LATEST_VER. All done!"

