# NOTE: make sure this is set before oh-my-zsh is loaded
# If omitted, or empty, HISTSIZE is assumed to be 1 which makes for an unergonomic history experience
HISTSIZE=10000
SAVEHIST=10000

export FZF_DEFAULT_OPTS="--reverse --height=20% --multi"
export FZF_CTRL_T_OPTS="--preview 'cat {}'"
if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
fi

# vi bindings
bindkey -v
set -o vi

# NOTE: plugins need to load before OMZ
plugins=(
  git
  osx
  ruby
  golang
  colored-man-pages
  kubectl
  fzf               # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/fzf
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

## vi bindings
#bindkey -v
#set -o vi
## reverse history search
# disabled 20210414 when enabling fzf
#bindkey "^R" history-incremental-search-backward
# NOTE: fzf plugin enables the following controls:
# - ctrl-r: replace reverse history search
# - ctrl-t: find files, insert file at cursor
# - alt-c: ??


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
# Disabled because we have fzf ctrl-t+ctrl-r
#zle -N ctrlp
#bindkey "^p" ctrlp


webkit-timestamp-ago() {
  # https://timothycomeau.com/writing/chrome-history
  # processes a strange chrome timestamp into a relative
  # string that shows like 2d or 58s or 24m
  tnow="$(date +%s)"
  x="$(( ${1} / 1000000 - 11644473600))"
  dur=$((tnow - x))
  if [[ $dur -lt 60 ]] ; then
    echo "${dur}s"
  elif [[ $dur -lt 3600 ]] ; then
    echo "$((dur/60))m"
  elif [[ $dur -lt 86400 ]] ; then
    echo "$((dur/3600)))h"
  else
    echo "$((dur/86400))d"
  fi
}

collect-browser-history(){
  sep='{::}'
  cols=$(( COLUMNS / 3 ))
  # collect all history entries from all browsers, spit em out to stdout
  # in a sorted order, so recent is last
  tnow="$(date +%s)"
  find  ~/Library/Application\ Support/Google/Chrome/ -type f -name History | while read h
  do
    #echo "loading history from $h" >&2
    # sqlite is annoying and gives IO errors unless we copy it for single access
      #"select last_visit_time, substr(title, 1, $cols), url from urls"
      #datetime(time/1e6-11644473600,'unixepoch','localtime')
    cp $h /tmp/h
    sqlite3 -readonly -separator {::} /tmp/h \
      "select last_visit_time, substr(title, 1, $cols), url from urls"

  done | sort -rn| awk -F $sep '
        {
          tnow='"$(date +%s)"'
          # record our URL, and skip if we have seen it before
          !urls[$3]++;
          raw_timestamp=$1 ;
          as_unix=(raw_timestamp / 1000000 - 11644473600) ;
          last_access="?"
          elapsed_seconds=tnow - as_unix
          if (elapsed_seconds < 60)
            last_access=int(elapsed_seconds) "s";
          else if (elapsed_seconds < 3600)
            last_access=int(elapsed_seconds/60) "m";
          else if (elapsed_seconds < 86400)
            last_access=int(elapsed_seconds/3600) "h";
          else
            last_access=int(elapsed_seconds/86400) "d";

          if (urls[$3] == 1)
            printf "%-'$cols's [%s]  \x1b[36m%s\x1b[m\n", $2, last_access, $3 ;
        }'
}

# look thru browser history with fzf with ctrl-h
browser-history(){
  collect-browser-history | fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
}
zle -N browser-history
bindkey "^h" browser-history

# ctrl-b will open bookmarks in fzf
_bookmarks-fzf () {
  echo
  bookmarks-fzf
  zle redisplay
}

zle -N _bookmarks-fzf
bindkey "^b" _bookmarks-fzf

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

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

