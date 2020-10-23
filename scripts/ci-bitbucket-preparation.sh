#!/usr/bin/env sh
set -e

setup_key(){
    echo "--------------------------------------------------"
    echo " Setup SSH-Key "
    echo "--------------------------------------------------"
    ### SETUP SSH ###
    "which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )"
    mkdir -p ~/.ssh
    # (umask  077 ; echo $MYAPP_SSH_PRIVATE_KEY | base64 --decode > ~/.ssh/id_rsa)
    # (umask  077 ; echo $MYAPP_KNOWN_HOSTS | base64 --decode > ~/.ssh/known_hosts)
    echo "$MYAPP_SSH_PRIVATE_KEY" | base64 --decode > ~/.ssh/id_rsa
    echo "$MYAPP_KNOWN_HOSTS" | base64 --decode > ~/.ssh/known_hosts
    chmod 700 ~/.ssh/id_rsa
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    ssh-keyscan -H 'bitbucket.org' >> ~/.ssh/known_hosts
    chmod 644 ~/.ssh/known_hosts
    echo "--------------------------------------------------"
    echo "--- DONE ---"
    echo ""
    sleep 1
}

install_library(){
    echo "--------------------------------------------------"
    echo " Install Library "
    echo "--------------------------------------------------"
    ### INSTALL LIBRARY ###
    gem install bundler
    bundle install
    echo "--------------------------------------------------"
    echo "--- DONE ---"
    echo ""
    echo "--------------------------------------------------"
    echo " Finish At : `date`"
    echo "--------------------------------------------------"
    echo "--- SUCCESS ALL DONE --- "
    echo ""
}

main(){
    export MYAPP_SSH_PRIVATE_KEY=$1
    export MYAPP_KNOWN_HOSTS=$2
    setup_key $MYAPP_SSH_PRIVATE_KEY $MYAPP_KNOWN_HOSTS
    install_library
}

### START HERE ###
main $1 $2


### How Execute Bash ####
# ./ci-bitbucket-preparation.sh [ssh_private_key] [known_hosts]
