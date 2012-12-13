
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


BLUE=`tput setf 1`
GREEN=`tput setf 2`
CYAN=`tput setf 3`
RED=`tput setf 4`
MAGENTA=`tput setf 5`
YELLOW=`tput setf 6`
WHITE=`tput setf 7`


#PS1='[\u@\h \W]\$ '
white='\[\e[1;31m\]'
end='\[\e[m\]'
PS1='\[\e[1;31m\]-=[\[\e[m\] \[\e[1;34m\]\u\[\e[m\]@\[\e[1;34m\]\h:\[\e[1;32m\]\W \[\e[1;31m\]]=- \[`if [[ \$? -eq 0 ]]; then echo "\$GREEN" ; else echo "\$RED" ; fi`\]\$ \[\e[m\]' 
#PS1="\[\033[1;34m\]┌─[\[\033[0m\033[1;32m\]\u\[\033[0m\] @ \[\033[1;36m\]\h\[\033[0m\033[1;34m\]]-[\t\[\033[1;34m\]]\n\[\033[1;34m\]└─[\[\033[0m\]\w\[\033[1;34m\]]-[\[\033[0m\033[1;35m\]\$\[\033[0m\033[1;34m\]]>\[\033[0m\] "


#PS1='\[\e[0;32m\]\u \[\e[1;34m\]\w \[\e[1;32m\]\$ \[\e[1;37m\] '
#PS1='\[\e[0;31m\]\u \[\e[1;34m\]\w \[\e[0;31m\]\$ \[\e[0;32m\] '

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
alias '..'='cd ..'
alias '....'='cd ../..'
alias .='source'
alias ssh='ssh -q'
alias scp='scp -q'

export PATH=$PATH:~/bin
export VISUAL=vim
export EDITOR=vim
export PAGER='less'
export PS1='\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\$ '
export GREP_COLOR='1;33'

# eval `dircolors -b`
export LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.xz=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'



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
#case "$TERM" in
#screen,xterm-color,xterm-256color)
#  PROMPT_COMMAND='echo -ne "\033k$HOSTNAME\033\\"'
#  #echo -ne "\033k$HOSTNAME\033\\"
#  ;;
#esac
case $TERM in
 xterm*|rxvt*)
 PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}[`basename ${PWD}`]\007"'
 ;;
 screen*)
# screen responds to ESC k TITLEHERE ESC \. print ESC with ctrl+v,escape. dont forget to escape \ so the shell doesnt wait for the next char
 PROMPT_COMMAND='echo -ne "\033k${HOSTNAME}:[`basename ${PWD}`]\033\\"'
 ;;
 *)
 ;;
esac
