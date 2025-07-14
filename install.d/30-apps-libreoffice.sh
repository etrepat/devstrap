# LibreOffice
# https://libreoffice.org/

echo "=> Intalling LibreOffice..."
sudo add-apt-repository ppa:libreoffice/ppa
sudo apt-get update
sudo apt-get install -y libreoffice libreoffice-l10n-es libreoffice-l10n-ca
