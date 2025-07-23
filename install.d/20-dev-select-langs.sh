#!/usr/bin/env bash
# Install selected programming languages

if [[ ! -v DEVSTRAP_SELECTED_LANGS ]]; then
    DEVSTRAP_AVAILABLE_LANGS=("Elixir" "Go" "Java" "Node.js" "PHP" "Python" "Ruby" "Rust")
    DEVSTRAP_SELECTED_LANGS=$(${DEVSTRAP_GUM} choose "${DEVSTRAP_AVAILABLE_LANGS[@]}" --no-limit --height 10 --header "Please, select the programming languages to install")
fi

if [[ -n "${DEVSTRAP_SELECTED_LANGS}" ]]; then
    cd ${DEVSTRAP_TMP}

	for pl in ${DEVSTRAP_SELECTED_LANGS}; do
		case $pl in
		Elixir)
            echo "=> (mise) Installing (latest) Erlang+Elixir..."
			mise use --global erlang@latest
			mise use --global elixir@latest
			mise x elixir -- mix local.hex --force
			;;
		Go)
            echo "=> (mise) Installing (latest) Go..."
			mise use --global go@latest
			;;
		Java)
            echo "=> (mise) Install latest Java..."
			mise use --global java@latest
			;;
		Node.js)
            echo "=> (mise) Installing node LTS..."
			mise use --global node@lts
			;;
		PHP)
            echo "=> Installing PHP (latest)..."
            yay -S --noconfirm --needed php php-redis php-memcached php-imagick php-gd php-pgsql php-tidy
            # Install composer
            php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
            php composer-setup.php --quiet && sudo mv composer.phar /usr/local/bin/composer
            rm -f composer.setup
			;;
		Python)
            echo "=> (mise) Installing latest Python..."
			mise use --global python@latest
			;;
		Ruby)
            echo "=> (mise) Installing latest Ruby..."
			mise use --global ruby@3.3
			;;
		Rust)
            echo "=> Installing Rust (via rustup)..."
            bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)" -- -y
			;;
		esac
	done

    cd -
fi
