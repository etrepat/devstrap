#!/usr/bin/env bash

CONFIG="$HOME/.bashrc"

x() {
  $* || (echo 'uops! something failed' 1>&2 && exit 1)
}

i() {
  x sudo apt-get install -y $*
}

m() {
  echo -e "\e[1;33m------>\e[0m \e[1;34m$*\e[0m"
}

t() {
  if [[ $# -eq 0 ]]; then
    echo $(date '+%s')
  else
    local  stime=$1
    etime=$(date '+%s')

    if [[ -z "$stime" ]]; then stime=$etime; fi

    dt=$((etime - stime))
    ds=$((dt % 60))
    dm=$(((dt / 60) % 60))
    dh=$((dt / 3600))
    printf '%d:%02d:%02d' $dh $dm $ds
  fi
}

T1=$(t)

sudo -k

m 'Updating system'
x sudo apt-get update -y
x sudo apt-get upgrade -y

m 'Generating SSH pub/priv keys if not present'
test ! -s ~/.ssh/id_rsa.pub && x ssh-keygen -q -t rsa -N ''

m 'Installing needed compilers & build tools'
i build-essential

m 'Installing needed libraries and dependencies'
i bison openssl libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt1-dev autoconf libc6-dev libncurses5-dev automake libtool libgdm-dev libffi-dev

m 'Installing cURL'
i curl

m 'Installing Git'
i git-core

m 'Installing SQLite 3 support'
i libsqlite3-0 libsqlite3-dev sqlite3

m 'Installing PostgreSQL support'
i postgresql postgresql-client postgresql-doc libpq-dev

m 'Installing Imagemagick client & devevelopment libraries'
i imagemagick libmagickcore-dev libmagickwand-dev

m 'Installing latest RVM (Ruby Version Manager)'
x curl -#L https://get.rvm.io | bash -s stable --autolibs=enabled
x echo '' >> $CONFIG
x echo '# RVM' >> $CONFIG
x echo '[[ -s ~/.rvm/scripts/rvm ]] && source ~/.rvm/scripts/rvm' >> $CONFIG
x source ~/.rvm/scripts/rvm

m 'Installing latest stable patch-level ruby and marking as default'
x rvm install 2.0.0-p0
x rvm use 2.0.0-p0 --default

m 'Installing bundler-exec script'
x curl -#L https://github.com/gma/bundler-exec/raw/master/bundler-exec.sh > ~/.bundler-exec.sh
x echo '' >> $CONFIG
x echo '# bundler-exec (https://github.com/gma/bundler-exec)' >> $CONFIG
x echo '[ -f ~/.bundler-exec.sh ] && source ~/.bundler-exec.sh' >> $CONFIG

m 'Installing Heroku toolbelt (CLI)'
x echo "deb http://toolbelt.heroku.com/ubuntu ./" | sudo tee /etc/apt/sources.list.d/heroku.list > /dev/null
x curl -#L https://toolbelt.heroku.com/apt/release.key | sudo apt-key add -
x sudo apt-get update
x sudo apt-get install -y heroku-toolbelt

m 'Installing xclip for easy commandline clipboard access'
i xclip

m 'Installing Tmux'
i tmux

m 'Installing Vim and exporting as default terminal editor'
i vim
x echo '' >> $CONFIG
x echo '# Set VIM as default text-mode editor' >> $CONFIG
x echo 'EDITOR=vim' >> $CONFIG
x echo 'export EDITOR' >> $CONFIG

m 'Installing Sublime-Text 2 via PPA'
x sudo add-apt-repository ppa:webupd8team/sublime-text-2
x sudo apt-get update
i sublime-text

m 'Prepending ~/bin to PATH when exists'
x echo '' >> $CONFIG
x echo '# Prepend ~/bin to PATH if it exists' >> $CONFIG
x echo 'test -d ~/bin &&' >> $CONFIG
x echo 'PATH=~/bin:$PATH' >> $CONFIG

m 'Adding a minimal set of aliases (cannot work without these)'
x echo "alias ls='ls -lFh --color=auto'" >> ~/.bash_aliases
x echo "alias df='df -h'" >> ~/.bash_aliases
x echo "alias pbcopy='xclip -selection cliboard'" >> ~/.bash_aliases
x echo "alias pbpaste='xclip -selection clipboard -o'" >> ~/.bash_aliases

m "All done! ~ $(t $T1)"
