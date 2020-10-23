########## CUSTOMIZE .zshrc ##########

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

### Path Ruby RBENV / RVM ###
export RBENV_ROOT="$HOME/.rbenv"
export RVM_ROOT="$HOME/.rvm"

### rbenv (Ruby) default ###
if [ -d "$RBENV_ROOT" ]
then
  export PATH="$RBENV_ROOT/bin:${PATH}"
  eval "$(rbenv init -)"
  export PATH="$RBENV_ROOT/plugins/ruby-build/bin:$PATH"
  # export RAILS_ENV=staging
else
  ### rvm (Ruby) - alternative ###
  if [ -d "$RVM_ROOT" ]
  then
    export PATH="$PATH:$RVM_ROOT/bin"
    source $RVM_ROOT/scripts/rvm

    # Set PATH alternatives using this:
    [[ -s "$RVM_ROOT/scripts/rvm"  ]] && source "$RVM_ROOT/scripts/rvm"
  fi
fi

### Path NVM (NodeJS Version Manager) ###
export NVM_ROOT="$HOME/.nvm"

if [ -d "$NVM_ROOT" ]
then
  [ -s "$NVM_ROOT/nvm.sh" ] && . "$NVM_ROOT/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

### tmux ###
# export TMUX_TMPDIR=~/.tmux/tmp

### JAVA PATH ###
export JAVA_HOME="/usr/lib/jvm/java-8-oracle"
export JRE_HOME="/usr/lib/jvm/java-8-oracle/jre"
# export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_121
# export JRE_HOME=/usr/lib/jvm/jdk.1.8.0_121/jre
export PATH=$PATH:$HOME/bin:$JAVA_HOME/bin:$JRE_HOME/bin
export JAVA_HOME
export JRE_HOME
export PATH

### GO-Lang $GOPATH ###
export GOPATH=$HOME/go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

### Docker ###
export DOCKER_CLIENT_TIMEOUT=300
export COMPOSE_HTTP_TIMEOUT=300

### Path pyenv (Python Version Manager) ###
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if [ -d "$PYENV_ROOT" ]
then
  # echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi'
  eval "$(pyenv init -)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f $HOME'/google-cloud-sdk/path.zsh.inc' ]; then . $HOME'/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f $HOME'/google-cloud-sdk/completion.zsh.inc' ]; then . $HOME'/google-cloud-sdk/completion.zsh.inc'; fi
