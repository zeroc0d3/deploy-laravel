#!/usr/bin/env sh

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
  git \
  bash \
  curl \
  wget \
  software-properties-common \
  openssh-server \
  openssh-client

git config --global user.name "Your Name Here"
git config --global user.email "your-github-email@example.com"


# ================================================================================================
#  SETUP SSH-KEYGEN (UNSECURE) - BLANK PASSWORD
# ================================================================================================
# /usr/bin/ssh-keygen -t rsa -b 4096 -C "your-github-email@example.com" -f $HOME/.ssh/id_rsa -q -N "";

# ================================================================================================
#  SETUP SSH-KEYGEN (SECURE)
# ================================================================================================
/usr/bin/ssh-keygen -t rsa -b 4096 -C "your-github-email@example.com"