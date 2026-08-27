#!/usr/bin/env bash
# Install selected programming languages

# Ensure languages have been selected (shared helper, single source of truth)
devstrap_prompt_langs

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
            rm -f composer-setup.php
			;;
		Python)
            echo "=> (mise) Installing latest Python..."
			mise use --global python@latest
			;;
		Ruby)
            echo "=> (mise) Installing latest Ruby..."
            mise use --global ruby@latest
            mise settings add idiomatic_version_file_enable_tools ruby
			;;
		Rust)
            echo "=> Installing Rust (via rustup)..."
            bash -c "$(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs)" -- -y
			;;
		esac
	done

    cd -
fi
