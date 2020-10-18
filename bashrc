# Check for an interactive session
[ -z "$PS1" ] && return
umask 0022

if [[ $(uname) == Darwin ]] ; then
  [[ -r ~/.profile-osx ]] && source ~/.profile-osx
  [[ -r ~/.bashrc-ddog ]] && source ~/.bashrc-ddog
  md5sum(){
    /sbin/md5 "$@"
  }
fi

# add in history searching
# up and down search for history entry beginning with that entry
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

set -o vi

[[ -f ~/.aliases ]] && source ~/.aliases

# make history unlimited
export HISTSIZE=
export HISTFILESIZE=

export PATH=$PATH:~/bin:~/local/bin:~/lang/bin:~/lang/usr/local/scala/bin:~/code/scripts:~/code/scripts/collins:/usr/sbin:/sbin:/usr/local/sbin:/usr/local/bin:~/.rvm/bin:/opt/local/bin:/opt/local/sbin:$GOPATH/bin:~/.cargo/bin
export MANPATH=$MANPATH:~/lang/share/man:~/lang/usr/local/scala/man
export VISUAL='vim'
export EDITOR='vim'
export PAGER='less'

#colors for solarized scheme
tput sgr0 # reset colors
if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
  BASE03=$(tput setaf 234)
  BASE02=$(tput setaf 235)
  BASE01=$(tput setaf 240)
  BASE00=$(tput setaf 241)
  BASE0=$(tput setaf 244)
  BASE1=$(tput setaf 245)
  BASE2=$(tput setaf 254)
  BASE3=$(tput setaf 230)
  YELLOW=$(tput setaf 136)
  ORANGE=$(tput setaf 166)
  RED=$(tput setaf 160)
  MAGENTA=$(tput setaf 125)
  VIOLET=$(tput setaf 61)
  BLUE=$(tput setaf 33)
  CYAN=$(tput setaf 37)
  GREEN=$(tput setaf 64)
else
  BASE03=$(tput setaf 8)
  BASE02=$(tput setaf 0)
  BASE01=$(tput setaf 10)
  BASE00=$(tput setaf 11)
  BASE0=$(tput setaf 12)
  BASE1=$(tput setaf 14)
  BASE2=$(tput setaf 7)
  BASE3=$(tput setaf 15)
  YELLOW=$(tput setaf 3)
  ORANGE=$(tput setaf 9)
  RED=$(tput setaf 1)
  MAGENTA=$(tput setaf 5)
  VIOLET=$(tput setaf 13)
  BLUE=$(tput setaf 4)
  CYAN=$(tput setaf 6)
  GREEN=$(tput setaf 2)
fi
BOLD=$(tput bold)
RESET=$(tput sgr0)

# show all exit statuses in the pipeline
# disabled 05-13-2013 gconradi - improperly escaped non-printing chars, caused messed up readline
# export PS1='\e[1;30m[\e[1;94m\t\e[1;30m] [\e[1;36m\]\u\e[1;30m@\e[1;36m\h\e[1;30m] ($(for r in ${PIPESTATUS[*]} ; do [ $r -eq 0 ] && echo -n "\e[1;30m $r" || echo -n " \e[0;31m$r\e[0m" ; done)\e[1;30m ) \e[0;91m\]\w\n\e[1;30m-> \$ \e[0m' #\e[0;97m'
# dont forget, when echoing colors, wrap non-printing chars in \[\] so bash doesnt count them to the line length
# lets precompute the color we want this host to be
#host_color="$(random_color $HOSTNAME)"
host_color="${MAGENTA}"
export PS1='\[${RESET}${BASE02}\]\[${BLUE}\]\t\[${BASE02}\] \[${CYAN}\]\u\[${BASE01}\]@\[${host_color}\]\h\[${BASE02}\] \[${BASE00}\] \[${BASE00}${BLUE}\]$(kctx)\[${BASE00}\] \[${CYAN}\]$(cdc)\[${BASE00}\] \[${ORANGE}\]\w$(is_git_repo && echo -n " \[${VIOLET}\]$(git_branch)\[${RESET}\]" && is_git_dirty && echo -n "\[${RED}\]🧹\[${RESET}\]") $(for r in ${PIPESTATUS[*]} ; do [ $r -eq 0 ] && echo -n "\[$BASE01\]$r" || echo -n "\[${RED}\]${r}\[${RESET}\]" ; done)\n\[${BASE00}\]🚀 \[${RESET}\]'

# fuck it. basically all terminals are shitty and broken
[[ $TERM == xterm ]] && export TERM=xterm-256color

#title screen's tabs with hostname
case $TERM in
 xterm*|rxvt*)
 #set tmux tab title to hostname of box
 #echo -n -e "\033k`uname -n`\033\\"  # only runs on source
 tab_command='echo -n -e "\033k`uname -n`\033\\"'
 #set window title to be more verbose
 verbose_window_command='echo -ne "\033]0;${USER}@${HOSTNAME}[`basename "${PWD}"`]\007"'
 window_status='echo -ne "\033]0;${USER}[`basename "${PWD}"`]\007"'
 #PROMPT_COMMAND="$tab_command ; $verbose_window_command"
 PROMPT_COMMAND="$verbose_window_command"
 ;;
 screen*)
# screen responds to ESC k TITLEHERE ESC \. print ESC with ctrl+v,escape. dont forget to escape \ so the shell doesnt wait for the next char
 #PROMPT_COMMAND='echo -ne "\033k${HOSTNAME}\033\\"'
 #PROMPT_COMMAND='echo -ne "\033k${HOSTNAME}:[`basename ${PWD}`]\033\\"'
 ;;
 *)
 ;;
esac

[[ -f ~/.rvm/scripts/rvm ]] && . ~/.rvm/scripts/rvm
#[[ -s ~/.gvm/scripts/gvm ]] && . ~/.gvm/scripts/gvm
# clobber the default gopath setup by gvm
export GOPATH=~/code/go

shopt -q nullglob
nge="$?"
shopt -qs nullglob
for f in ~/.bashrc-* ; do source $f ; done
[[ $nge == 1 ]] && shopt -qu nullglob

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

[[ -s "/Users/gabe/.gvm/scripts/gvm" ]] && source "/Users/gabe/.gvm/scripts/gvm"
