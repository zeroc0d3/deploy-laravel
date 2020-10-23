#!/usr/bin/env sh

# ================================================================================================
#  INSTALL RUBY
# ================================================================================================
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
    git \
    bash \
    curl \
    wget \
    apt-transport-https \
    ca-certificates \
    openssh-server \
    openssh-client \
    net-tools \
    vim-tiny \
    nano \
    iputils-ping \
    make \
    tmux \
    mc \
    g++ \
    gcc \
    autoconf \
    automake \
    bison \
    libc6-dev \
    libffi-dev \
    libgdbm-dev \
    libncurses5-dev \
    libsqlite3-dev \
    libtool \
    libyaml-dev \
    pkg-config \
    sqlite3 \
    zlib1g-dev \
    libgmp-dev \
    libreadline-dev \
    libssl-dev

gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable

source ~/.rvm/scripts/rvm

rvm install 2.7.1
rvm use 2.7.1 --default

gem update --system 3.0.8
gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
gem pristine rake
bundle install
