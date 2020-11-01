#!/usr/bin/env sh
# -----------------------------------------------------------------------------
#  ENCODE KEY
# -----------------------------------------------------------------------------
#  Author     : Dwi Fahni Denni (@zeroc0d3)
#  License    : Apache v2
# -----------------------------------------------------------------------------
set -e

chmod 755 ~/.ssh/id_rsa*

export ID_RSA=`base64 -w 0 < ~/.ssh/id_rsa`
export ID_RSA_PUB=`base64 -w 0 < ~/.ssh/id_rsa.pub`
export KNOWN_HOSTS=`base64 -w 0 < ~/.ssh/known_hosts`

openssl rsa -in id_rsa -outform pem > ~/.ssh/id_rsa.pem
export PEM_FILE=`base64 -w 0 < ~/.ssh/id_rsa.pem`

echo $ID_RSA > ~/.ssh/id_rsa.base64
echo $ID_RSA_PUB > ~/.ssh/id_rsa.pub.base64
echo $KNOWN_HOSTS > ~/.ssh/known_hosts.base64
echo $PEM_FILE > ~/.ssh/id_rsa.pem.base64

chmod 400 id_rsa*