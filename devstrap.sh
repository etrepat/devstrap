#!/usr/bin/env bash

CONFIG="$HOME/.bashrc"

x() {
  $* || (echo "uops! something failed" 1>&2 && exit 1)
}

i() {
  x sudo apt-get install -y $*
}

# Revoke previous sudo perms
sudo -k

echo "Updating system ..."
x sudo apt-get update -y
x sudo apt-get upgrade -y

echo "Generating SSH pub/priv keys if not present ..."
test ! -s ~/.ssh/id_rsa.pub && x ssh-keygen -q -t rsa

echo "Installing needed compilers & build tools ..."
i build-essential

echo "Installing needed libraries and dependencies ..."
i bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool

echo "Installing Curl ..."
i curl

echo "Installing Git ..."
i git-core

echo "Installing SQLite 3 support ..."
i libsqlite3-0 libsqlite3-dev sqlite3

echo "Installing PostgreSQL support ..."
i postgresql postgresql-client postgresql-doc libpq-dev

echo "Installing Imagemagick client & devevelopment libraries ..."
i imagemagick libmagickcore-dev libmagickwand-dev

echo "Installing latest RVM (Ruby Version Manager) ..."
x curl -L https://get.rvm.io | bash -s stable
x echo "" >> $CONFIG
x echo "# RVM" >> $CONFIG
x echo "[[ -s '~/.rvm/scripts/rvm' ]] && source '~/.rvm/scripts/rvm'" >> $CONFIG
x source ~/.rvm/scripts/rvm

echo "Installing latest stable patch-level ruby and marking as default ..."
x rvm install 1.9.3-p194
x rvm use 1.9.3-p194 --default

echo "Installing bundler-exec script ..."
x curl -L https://github.com/gma/bundler-exec/raw/master/bundler-exec.sh > ~/.bundler-exec.sh
x echo "" >> $CONFIG
x echo "# bundler-exec (https://github.com/gma/bundler-exec)" >> $CONFIG
x echo "[ -f ~/.bundler-exec.sh ] && source ~/.bundler-exec.sh" >> $CONFIG

echo "Installing Heroku toolbelt ..."
x wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

echo "Installing xclip for easy commandline clipboard access ..."
i xclip

echo "Installing Tmux ..."
i tmux

echo "Installing Vim and exporting as default terminal editor ..."
i vim
x echo "" >> $CONFIG
x echo "# Set VIM as default text-mode editor" >> $CONFIG
x echo "export EDITOR='vim'" >> $CONFIG

echo "Installing Sublime-Text 2 via PPA ..."
x sudo add-apt-repository ppa:webupd8team/sublime-text-2
x sudo apt-get update
i sublime-text

echo "Prepending ~/bin to PATH when exists ..."
x echo "" >> $CONFIG
x echo "# Prepend ~/bin to PATH if it exists" >> $CONFIG
x echo "test -d \"~/bin\" &&" >> $CONFIG
x echo "PATH=~/bin:$PATH" >> $CONFIG

echo "Adding a minimal set of aliases (cannot work without these) ..."
x echo "alias ls='ls -lFh --color=auto'" >> ~/.bash_aliases
x echo "alias df='df -h'" >> ~/.bash_aliases
x echo "alias pbcopy='xclip -selection cliboard'" >> ~/.bash_aliases
x echo "alias pbpaste='xclip -selection clipboard -o'" >> ~/.bash_aliases

echo "All done!"
