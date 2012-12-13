#           _                _                         _          
#   _______| |__  _ __ ___  | |__  _   _    __ _  __ _| |__   ___ 
#  |_  / __| '_ \| '__/ __| | '_ \| | | |  / _` |/ _` | '_ \ / _ \
# _ / /\__ \ | | | | | (__  | |_) | |_| | | (_| | (_| | |_) |  __/
#(_)___|___/_| |_|_|  \___| |_.__/ \__, |  \__, |\__,_|_.__/ \___|
#                                  |___/   |___/                  
#

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt beep
setopt correct
setopt extended_history
setopt SHARE_HISTORY # share history between open shells
setopt APPEND_HISTORY
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/gconradi/.zshrc'


#######################
#
# turn on verbose completion for help
#
#######################


zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true




######################
#
# do a compinstall
#
######################


autoload -Uz compinit
compinit
# End of lines added by compinstall
#
# custom added lines

alias pacup='yaourt -Syu --aur'
alias pacse='yaourt -Ss --aur'
alias pacrm='yaourt -R '
alias pacin='yaourt -Sy --aur'
alias pacreset='sudo rm /var/lib/pacman/db.lck'
alias ls='ls --color=always '
alias grep='grep --color=always '
alias less='less -R '
alias vi='vim'
alias isomount='sudo mount -t iso9660 -o loop'
#alias perlshell='perl -wn -e ' print "perl> " ; eval($_);'''
alias bc='bc -l'
alias update='yaourt -Syu --aur'
alias search='sudo yaourt -Sys --aur'
alias '..'='cd ..'
alias '....'='cd ../..'
alias 'flac2mp3'='for file in *.flac; do flac -cd "$file" | lame -b 256 -h - "${file%.flac}.mp3"; done'
alias sduo=sudo
alias usdo=sudo
alias suod=sudo
alias sdou=sudo
alias ll='ls -la'

extract () {
        if [ -f $1 ] ; then
                case $1 in
                        *.tar.bz2)      tar xvjf $1     ;;
                        *.tar.gz)       tar xvzf $1     ;;
                        *.bz2)          bunzip2 $1      ;;
                        *.rar)          unrar x $1      ;;
                        *.gz)           gunzip $1       ;;
                        *.tar)          tar xvf $1      ;;
                        *.tbz2)         tar xvjf $1     ;;
                        *.tgz)          tar xvzf $1     ;;
                        *.zip)          unzip $1        ;;
                        *.Z)            uncompress $1   ;;
                        *.7z)           7z x $1         ;;
                        *.xz)           xz -d $1        ;;
                        *)      echo "dont know what to do with '$1'..." ;;
                esac
        else
                echo "'$1' is not a valid archive type"
        fi
}

######
#
# now define suffix aliases
#
######

alias -s gz=tar xvzf
alias -s bz2=tar xjvf
alias -s txt=$EDITOR
alias -s jpg=eog

# key bindings
 bindkey "\e[1~" beginning-of-line
 bindkey "\e[4~" end-of-line
 bindkey "\e[5~" beginning-of-history
 bindkey "\e[6~" end-of-history
 bindkey "\e[3~" delete-char
 bindkey "\e[2~" quoted-insert
 bindkey "\e[5C" forward-word
 bindkey "\eOc" emacs-forward-word
 bindkey "\e[5D" backward-word
 bindkey "\eOd" emacs-backward-word
 bindkey "\e\e[C" forward-word
 bindkey "\e\e[D" backward-word
 bindkey "^H" backward-delete-word
# # for rxvt
 bindkey "\e[8~" end-of-line
 bindkey "\e[7~" beginning-of-line
# # for non RH/Debian xterm, can't hurt for RH/DEbian xterm
 bindkey "\eOH" beginning-of-line
 bindkey "\eOF" end-of-line
# # for freebsd console
 bindkey "\e[H" beginning-of-line
 bindkey "\e[F" end-of-line
# # completion in the middle of a line
 bindkey '^i' expand-or-complete-prefix

# custom bind for next and prev word :-)
# use ctrl+v then hit key combo
bindkey "^[[1;5D" backward-word 
bindkey "^[[1;5C" forward-word

HOSTNAME="`hostname`"
export PAGER='less'
export EDITOR='vim'
    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
   colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
   eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
   eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
   (( count = $count + 1 ))
    done
    PR_NO_COLOR="%{$terminfo[sgr0]%}"
# lefthand ps1
export PS1="[$PR_BLUE%n$PR_WHITE@$PR_GREEN%U%m%u$PR_NO_COLOR:$PR_RED%2c$PR_NO_COLOR]%(!.#.$) "
# righthand ps1
export RPS1="%(?..[ %B%?%b ]) $PR_LIGHT_YELLOW(%D{%m-%d %H:%M})$PR_NO_COLOR"
#RPROMPT=$'%(?..[ %B%?%b ])'

export TERM=xterm-color
export PATH=${PATH}:/opt/android-sdk/tools:/opt/android-sdk/platform-tools:/opt/java/bin:~/bin:/opt/dropbox/
