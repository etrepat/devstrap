# PHP
m "Installing PHP (latest)..."

# Add repository
# https://launchpad.net/~ondrej/+archive/ubuntu/php
# The main PPA for supported PHP versions with many PECL extensions
sudo add-apt-repository -y ppa:ondrej/php

# Install cli & suitable set of extensions for Laravel development
sudo apt-get install -y php8.3-cli php8.3-common php8.3-curl php8.3-gd \
        php8.3-intl php8.3-mbstring php8.3-opcache php8.3-pgsql \
        php8.3-readline php8.3-soap php8.3-xml php8.3-zip php8.3-bcmath \
        php8.3-tidy php8.3-ssh2 php-memcached php-redis php8.3-imagick \

# Install composer
cd $DEVSTRAP_TMP
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php --quiet && sudo mv composer.phar /usr/local/bin/composer
rm -f composer.setup
cd -
