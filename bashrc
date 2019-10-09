# Check for an interactive session
[ -z "$PS1" ] && return
umask 0022

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

[[ $(uname) == Darwin ]] && md5sum(){ 
  /sbin/md5 "$@"
}

# add in history searching
# up and down search for history entry beginning with that entry
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

set -o vi

alias map="docker run -e TERM_PROGRAM=iTerm.app registry.tumblr.net/slackbots/mapbot:master-1117679 cli.py"
if type -P nvim 2>/dev/null &>/dev/null ; then
  alias vi=nvim
  alias vim=nvim
else
  alias vi=vim
  unalias vim || :
fi
alias ls='ls -G'
alias lös=ls
alias exit='clear; exit'
alias ll='ls -la'
alias la='ls -la'
alias lr='ls -laR'
alias less='less -R '
alias dude=sudo
alias suod=sudo
alias sduo=sudo
alias bc='bc -l'
alias   '..'='cd ..'
alias  '...'='cd ../..'
alias '....'='cd ../..'
alias .='source'
alias isomount='sudo mount -t iso9660 -o loop'
#alias perlshell='perl -wn -e ' print "perl> " ; eval($_);'''
alias ssh='ssh -qA'
alias scp='scp -q'
alias psa='ps aux | grep '
alias ss="sudo su"
alias gitc="git checkout"
alias gits="git status"
alias gitb="git branch"
alias gitf="git fetch"
alias gitp="git pull"
alias gitup="git checkout master && git pull origin master"
alias gg="git grep"
alias kctl="kubectl"
alias ktl="kubectl"

# make history unlimited
export HISTSIZE=
export HISTFILESIZE=

export PATH=$PATH:~/bin:~/local/bin:~/lang/bin:~/lang/usr/local/scala/bin:~/code/scripts:~/code/scripts/collins:/usr/sbin:/sbin:/usr/local/sbin:/usr/local/bin:~/.rvm/bin:/opt/local/bin:/opt/local/sbin:$GOPATH/bin:~/.cargo/bin
export MANPATH=$MANPATH:~/lang/share/man:~/lang/usr/local/scala/man
export VISUAL='vim'
export EDITOR='vim'
export PAGER='less'
export GREP_COLOR='1;33'
export P4CONFIG=~/.p4rc
# prepend history output with timestamps
export HISTTIMEFORMAT="%F %T - "

is_git_repo(){
  git rev-parse --is-inside-git-dir &>/dev/null
}
git_branch(){
  git rev-parse --symbolic-full-name --abbrev-ref HEAD
}
is_git_dirty(){
  [ -n "$(git status --short)" ]
}

random_color(){
  # spits out a random color based on $RANDOM or your input
  if [[ -z $1 ]] ; then
    r=$RANDOM
  else
    h="$(md5sum <<< "$1")"
    # make sure we bound the size of the int we get from converting hash to int
    subst="${h:0:6}"
    r="$((0x${subst%% *} ** 2))"
  fi
  # seems to give a better distribution if 125 is repeated
  color_codes=(125 136 166 160 125 61 33 37 64)
  i=$(($r % ${#color_codes[@]}))
  echo -n "$(tput setaf ${color_codes[$i]})"
}


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
host_color="$(random_color $HOSTNAME)"
export PS1='\[${RESET}${BASE02}\][\[${BLUE}\]\t\[${BASE02}\]] [\[${CYAN}\]\u\[${BASE01}\]@\[${host_color}\]\h\[${BASE02}\]] \[${BASE00}\]($(for r in ${PIPESTATUS[*]} ; do [ $r -eq 0 ] && echo -n "\[$BASE01\] $r" || echo -n " \[${RED}\]${r}\[${RESET}\]" ; done)\[${BASE00}\] ) \[${ORANGE}\]\w$(is_git_repo && echo -n " \[${GREEN}\]$(git_branch)\[${RESET}\]" && is_git_dirty && echo -n "\[${RED}\]*\[${RESET}\]")\n\[${BASE00}\]-> \[$(random_color)\]\$ \[$RESET\]'
# random color explosion
#export PS1='\[${RESET}$(random_color)\][\[$(random_color)\]\t\[$(random_color)\]] [\[$(random_color)\]\u\[$(random_color)\]@\[$(random_color)\]\h\[$(random_color)\]] \[$(random_color)\]($(for r in ${PIPESTATUS[*]} ; do [ $r -eq 0 ] && echo -n "\[$(random_color)\] $r" || echo -n " \[$(random_color)\]${r}\[$(random_color)\]" ; done)\[$(random_color)\] ) \[$(random_color)\]\w$(is_git_repo && echo -n " \[$(random_color)\]$(git_branch)\[$(random_color)\]" && is_git_dirty && echo -n "\[$(random_color)\]*\[$(random_color)\]")\n\[$(random_color)\]-> $(random_color)\$ \[$RESET\]'
#export PS1='\[\e[1;30m\][\[\e[1;94m\]\t\[\e[1;30m\]] [\[\e[1;36m\]\u\[\e[1;30m\]@\[\e[1;36m\]\h\[\e[1;30m\]] ($(for r in ${PIPESTATUS[*]} ; do [ $r -eq 0 ] && echo -n "\[\e[1;30m\] $r" || echo -n " \[\e[0;31m\]$r\[\e[0m\]" ; done)\[\e[1;30m\] ) \[\e[0;91m\]\w\n\[\e[1;30m\]-> \$ \[\e[0m\]'

extract () {
	if [ -f $1 ] ; then
		case $1 in
			*.tar.bz2)	tar xvjf $1	;;
			*.tar.gz)	tar xvzf $1	;;
			*.bz2)		bunzip2 $1	;;
			*.rar)		unrar x $1	;;
			*.gz)		gunzip $1	;;
			*.tar)		tar xvf $1	;;
			*.tbz2)		tar xvjf $1	;;
			*.tgz)		tar xvzf $1	;;
			*.zip)		unzip $1	;;
			*.Z)		uncompress $1	;;
			*.7z)		7z x $1		;;
			*)	echo "dont know what to do with '$1'..." ;;
		esac
	else
		echo "'$1' is not a valid archive type"
	fi
}

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

# throw things onto hastebin
haste(){
  url="http://hastebin.com"
  d="$(cat $1)" # read from file if given, else stdin
  [ $? != 0 ] && return 1
  r="$(curl -s -d "$d" "$url/documents")"
  # if all cool, generate a link from the json response
  #[ $? = 0 ] && echo "$r"|awk -F'\\W+' "{print \"$url/\"\$3}"  # apparently awk on OSX is too crufty to support regex in -F
  [ $? = 0 ] && echo "$r"|perl -ne "/\W+\w+\W+(\w+)\W+/ and print \"$url/\$1\n\";"
}


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

showcolors() {
  for i in {0..255} ; do
    printf "\x1b[38;5;${i}mcolour${i}\n"
  done
}

# setup ssh tunnnel
# i.e. tunnel gconradi@jumpbox dmzhost1 1235 80
# wget localhost:1235
sshtunnel(){
  jump="$1"
  remote="$2"
  localport="${3:-1234}"
  jumpport=22
  remoteport="${4:-22}"
  echo -e "Tunneling localhost:$localport -> $jump:$jumpport -> $remote:$remoteport\nctrl-c to stop"
  echo ssh -N -L "$localport:$remote:$remoteport" "$jump"
  ssh -N -L "$localport:$remote:$remoteport" "$jump"
}

collinsdc() {
  if [[ -z $1 ]] ; then
    l=$(basename $(readlink ~/.collins.yml))
    echo "${l##.collins.yml.}"
  else
    if [[ ! -f ~/.collins.yml.$1 ]] ; then
      echo "No collins config found for $1" >&2
      return 2
    fi
    ln -sfn ~/.collins.yml.$1 ~/.collins.yml && echo "Using collins config for $1"
  fi
}

flac2mp3() {
  echo "Converting ${1} to mp3" >&2
  ffmpeg -i "$1" -qscale:a 0 "${1/%flac/mp3}"
}

aiff2flacbatch() {
  echo "Converting *.aiff to *.flac" >&2
  for f in *.aiff ; do ffmpeg -i "$f" "${f%.aiff}.flac" ; done
}

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

cidr2range(){
  [[ -z $1 ]] && echo "Specify a CIDR as the first argument" >&2 && return 1
  ruby -ripaddr -e "puts IPAddr.new(ARGV.first).to_range.to_a.map(&:to_s).join(' ')" $1
}

epoch2date(){
  [[ -z $1 ]] && echo "Specify an epoch timestamp as first argument" >&2 && return 1
  ruby -e 'puts "#{ARGV.first} => #{Time.at(ARGV.first.to_i).to_s}"' -- $1
}

