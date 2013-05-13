# Check for an interactive session
[ -z "$PS1" ] && return

# enable bash completion in interactive shells
if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
fi

# add in history searching
# up and down search for history entry beginning with that entry
bind '"\e[A"':history-search-backward
bind '"\e[B"':history-search-forward

set -o vi

#BLUE=`tput setf 1`
#GREEN=`tput setf 2`
#CYAN=`tput setf 3`
#RED=`tput setf 4`
#MAGENTA=`tput setf 5`
#YELLOW=`tput setf 6`
#WHITE=`tput setf 7`

alias vi=vim
alias ls='ls --color=auto'
alias lös=ls
alias exit='clear; exit'
alias ll='ls -la'
alias la='ls -la'
alias lr='ls -laR'
alias grep='grep --color=auto'
alias egrep='egrep --color=always '
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
alias ssh='ssh -q'
alias scp='scp -q'
alias p4sync="p4 sync ~/p4_work/unix/...#head"
alias mmlsq='sudo mmlsquota --block-size=auto -j'
alias mmrepq='sudo mmrepquota --block-size=auto -j'
alias psa='ps aux | grep '
alias ss="sudo su"

export PATH=$PATH:~/bin:~/local/bin:~/lang/bin:~/lang/usr/local/scala/bin
export MANPATH=$MANPATH:~/lang/share/man:~/lang/usr/local/scala/man
export VISUAL='vim'
export EDITOR='vim'
export PAGER='less'
export GREP_COLOR='1;33'
export P4CONFIG=~/.p4rc
# show all exit statuses in the pipeline
# disabled 05-13-2013 gconradi - improperly escaped non-printing chars, caused messed up readline
# export PS1='\e[1;30m[\e[1;94m\t\e[1;30m] [\e[1;36m\]\u\e[1;30m@\e[1;36m\h\e[1;30m] ($(for r in ${PIPESTATUS[*]} ; do [ $r -eq 0 ] && echo -n "\e[1;30m $r" || echo -n " \e[0;31m$r\e[0m" ; done)\e[1;30m ) \e[0;91m\]\w\n\e[1;30m-> \$ \e[0m' #\e[0;97m'
export PS1='\[\e[1;30m\][\[\e[1;94m\]\t\[\e[1;30m\]] [\[\e[1;36m\]\u\[\e[1;30m\]@\[\e[1;36m\]\h\[\e[1;30m\]] ($(for r in ${PIPESTATUS[*]} ; do [ $r -eq 0 ] && echo -n "\[\e[1;30m\] $r" || echo -n " \[\e[0;31m\]$r\[\e[0m\]" ; done)\[\    e[1;30m\] ) \[\e[0;91m\]\w\n\[\e[1;30m\]-> \$ \[\e[0m\]'

# eval `dircolors -b`
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.xz=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'

# set up ssh-agent
# requires either ForwardAgent yes or -A in ssh
#SSHAGENT=/usr/bin/ssh-agent
#SSHAGENTARGS="-s"
#if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
#  # no agent running, set up the socket
#  eval `$SSHAGENT $SSHAGENTARGS`
#  trap "kill $SSH_AGENT_PID" 0
#  ssh-add
#fi
## rely on ssh to find the correct socket (pointed to by this file)
## .ssh/rc runs before this is sourced
##export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
#
#r(){
#  if [[ -n $TMUX ]] ; then
#    NEW_SSH_AUTH_SOCK=`tmux showenv|grep '^SSH_AUTH_SOCK' |cut -d = -f 2`
#    if [[ -n $NEW_SSH_AUTH_SOCK ]] && [[ -S $NEW_SSH_AUTH_SOCK ]] ; then
#      SSH_AUTH_SOCK=$NEW_SSH_AUTH_SOCK
#    fi
#  fi
#}



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

#title screen's tabs with hostname
case $TERM in
 xterm*|rxvt*)
 #set tmux tab title to hostname of box
 #echo -n -e "\033k`uname -n`\033\\"  # only runs on source
 tab_command='echo -n -e "\033k`uname -n`\033\\"'
 #set window title to be more verbose
 verbose_window_command='echo -ne "\033]0;${USER}@${HOSTNAME}[`basename ${PWD}`]\007"'
 PROMPT_COMMAND="$tab_command ; $verbose_window_command"
 ;;
 screen*)
# screen responds to ESC k TITLEHERE ESC \. print ESC with ctrl+v,escape. dont forget to escape \ so the shell doesnt wait for the next char
 PROMPT_COMMAND='echo -ne "\033k${HOSTNAME}\033\\"'
 #PROMPT_COMMAND='echo -ne "\033k${HOSTNAME}:[`basename ${PWD}`]\033\\"'
 ;;
 *)
 ;;
esac

# Run commands on all nodes in a gpfs cluster
# runs $2 on $1's nodes
# doallgpfs deva 'uname -r'
doallgpfs(){
  case "$1" in
    "a")
      host=gpfsa01
    ;;
    "b")
      host=gpfsb01
    ;;
    "deva")
      host=gpfsdeva01
    ;;
    *)
      echo "I dont know what cluster $1 is!"
      return 1
    ;;
  esac
  
  # fetch nodes from cluster
  output="$(ssh $host sudo /usr/lpp/mmfs/bin/mmlsnode)"
  if [ $? -ne 0 ] ; then
    echo "There was an error fetching the nodelist from $host"
    return 1
  fi
  nodes=($(echo -e "$output" | tail -1 | awk '{$1="";print $0;}'))

  if [ -z "$2" ] ; then
    # just list the nodes
    echo "Nodes in cluster $1: ${nodes[@]}"
  else
    echo "Running '$2' on cluster $1..."
    for n in ${nodes[@]} ; do
      echo "$n: $(ssh $n "$2")"
    done
  fi


}

# if using rvm, i dont want to source it every time i run something
rails (){
  which --skip-functions rails >&- 2>&-
  if [ "$?" -eq "0" ] ; then
    command rails $@
  else
    source ~/.rvm/scripts/rvm
    command rails $@
  fi
}


