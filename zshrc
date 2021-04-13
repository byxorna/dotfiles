# NOTE: make sure this is set before oh-my-zsh is loaded
# If omitted, or empty, HISTSIZE is assumed to be 1 which makes for an unergonomic history experience
HISTSIZE=10000
SAVEHIST=10000

# NOTE: plugins need to load before OMZ
plugins=(
  git
  osx
  ruby
  golang
  colored-man-pages
  kubectl
)

if [[ -r ~/.oh-my-zsh ]] ; then
  export ZSH="$HOME/.oh-my-zsh"
  source $ZSH/oh-my-zsh.sh
  source $HOME/code/dotfiles/zsh/themes/byxorna.zsh-theme
else
  # setup oh-my-zsh if missing
  echo -n "oh-my-zsh is not setup yet. do you want to install it? y/n " >&2
  read install
  if [[ $install == y ]] ; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <&-
    # the installer is bossy and overwrites our local config, so ensure
    echo -n "linking .zshrc to ~/code/dotfiles/zshrc"
    ln -sfn ~/code/dotfiles/zshrc ~/.zshrc
    source ~/.zshrc
  fi
fi

## disabled 2021.04.13, autocomplete screws with key bindings
#test -d $HOME/code/dotfiles/zsh/plugins/zsh-autocomplete && source $HOME/code/dotfiles/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# vi bindings
bindkey -v
set -o vi
# reverse history search
bindkey "^R" history-incremental-search-backward

umask 0022

if [[ $(uname) == Darwin ]] ; then
  [[ -r ~/.profile-osx ]] && source ~/.profile-osx
  [[ -r ~/.bashrc-ddog ]] && source ~/.bashrc-ddog
  md5sum(){
    /sbin/md5 "$@"
  }
fi

# Appends every command to the history file once it is executed
setopt inc_append_history

# up arrow for backwards history search
# https://unix.stackexchange.com/questions/324623/how-to-make-oh-my-zsh-history-behavior-similar-to-bashs
bindkey "$terminfo[kcuu1]" up-history
bindkey "$terminfo[kcud1]" down-history

[[ -f ~/.aliases ]] && source ~/.aliases

# hook up ctrl-p on the line to launch vim's ctrlp
# make sure this runs after aliases are configured, so we use nvim if present
# https://www.reddit.com/r/zsh/comments/2uyo2a/launch_vims_ctrlp_from_zsh/
ctrlp() {
  </dev/tty vim -c CtrlP
}
zle -N ctrlp
bindkey "^p" ctrlp

fzfvim() {
  IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} -p "${files[@]}"
}
zle -N fzfvim
bindkey "^e" fzfvim

# launch a fzf session to edit files with ctrl-e (kinda like ctrl-p)
#

[[ -f ~/.rvm/scripts/rvm ]] && . ~/.rvm/scripts/rvm
# clobber the default gopath setup by gvm
export GOPATH=~/code/go

SSHAGENT=/usr/bin/ssh-agent
# OSX/some DEs start an agent for you, so just take that
TARGET_SOCK="${SSH_AUTH_SOCK:-$HOME/.ssh/agent.sock}"
[[ ! -S $SSH_AUTH_SOCK ]] && unset SSH_AUTH_SOCK
[[ -r $TARGET_SOCK && -S $TARGET_SOCK && ( $SSH_AUTH_SOCK != $TARGET_SOCK || -z $SSH_AUTH_SOCK ) ]] && export SSH_AUTH_SOCK="$TARGET_SOCK"
if [[ -z $SSH_AUTH_SOCK && ! -S $TARGET_SOCK && -x $SSHAGENT ]]; then
  eval `$SSHAGENT -s -a $TARGET_SOCK`
  # prevent agent from dying whenever the spawning terminal is closed
  #trap "kill $SSH_AGENT_PID" 0
fi
# add key only if it isnt already added. this assumes you are using rsa keys...
# TODO: determine the default key that ssh-add uses programmatically
ssh-add -l|grep -q "$(ssh-keygen -lf ~/.ssh/id_rsa|awk '{print $2}')" || ssh-add

# launch tmux session if we arent already inside one, and tmux is installed
if [[ -z $TMUX ]] ; then
  if type -p tmux &>/dev/null ; then
    if tmux ls &>/dev/null ; then
      # attach to whatever first session is available to us by default
      # dont exec though, because we want to be able to launch a new session and tmux
      # on a remote host
      tmux a
    else
      # create a new session
      tmux
    fi
  fi
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# emulate bash's help command
function help(){
    bash -c "help $@"
}
