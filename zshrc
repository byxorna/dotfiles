# NOTE: make sure this is set before oh-my-zsh is loaded
# If omitted, or empty, HISTSIZE is assumed to be 1 which makes for an unergonomic history experience
HISTSIZE=10000
SAVEHIST=10000

if [[ -r .oh-my-zsh ]] ; then
  export ZSH="$HOME/.oh-my-zsh"
  source $ZSH/oh-my-zsh.sh
  source $HOME/code/dotfiles/zsh/themes/byxorna.zsh-theme
fi

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

plugins=(
  git
  osx
  ruby
  golang
)

# Appends every command to the history file once it is executed
setopt inc_append_history
# Reloads the history whenever you use it
setopt share_history

# up arrow for backwards history search
# https://unix.stackexchange.com/questions/324623/how-to-make-oh-my-zsh-history-behavior-similar-to-bashs
bindkey "$terminfo[kcuu1]" up-history
bindkey "$terminfo[kcud1]" down-history

alias vi=nvim
alias vim=nvim
alias ll='ls -la'
alias la='ls -la'
alias lr='ls -laR'
alias less='less -R '
alias bc='bc -l'
alias   '..'='cd ..'
alias  '...'='cd ../..'
alias '....'='cd ../..'
alias .='source'
alias isomount='sudo mount -t iso9660 -o loop'
alias ssh='ssh -A'
alias scp='scp -q'

# git helpers
alias gitc="git checkout"
alias gits="git status"
alias gitb="git branch"
alias gitf="git fetch"
alias gitp="git pull"
alias gg="git grep"
alias wya="git show"

# kubernetes helpers
alias kctl="kubectl"
alias ktl="kubectl"
alias k="kubectl"
alias kc="kubectl config use-context"
alias kcs="kubectl config get-contexts"
alias kui="k9s"

alias c="collins"

export PATH=$PATH:~/bin:~/local/bin:~/lang/bin:~/lang/usr/local/scala/bin:~/code/scripts:~/code/scripts/collins:/usr/sbin:/sbin:/usr/local/sbin:/usr/local/bin:~/.rvm/bin:/opt/local/bin:/opt/local/sbin:$GOPATH/bin:~/.cargo/bin
export VISUAL='vim'
export EDITOR='vim'
export PAGER='less'

is_git_repo(){
  git rev-parse --is-inside-git-dir &>/dev/null
}
git_branch(){
  git rev-parse --symbolic-full-name --abbrev-ref HEAD
}
is_git_dirty(){
  [ -n "$(git status --short)" ]
}

# show the active collins dc
cdc() {
  if [[ -L ~/.collins.yml ]] ; then
    echo "$(readlink ~/.collins.yml|awk -F. '{print $4}')"
  else
    echo "?"
  fi
}

# show the active kubernetes context
kctx () {
  if type -p kubectl >/dev/null && test -r ~/.kube/config ; then
    kubectl config current-context
  fi
}

# login to all configured clusters in kubeconfig and do the dance for oauth
kloginall() {
  for ctx in $(kubectl config get-contexts -o name) ; do
    kubectl login $ctx
    kubectl get po -n default &>/dev/null || :
  done
}

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

[[ -f ~/.rvm/scripts/rvm ]] && . ~/.rvm/scripts/rvm
# clobber the default gopath setup by gvm
export GOPATH=~/code/go

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

wav2flac() {
  echo "Converting ${1} to flac" >&2
  ffmpeg -i "$1" -qscale:a 0 "${1/%wav/flac}"
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

httpdme() {
  port="${1:-8000}"
  echo "Launching http server on $port for root $(pwd)"
  ruby -run -e httpd . -p $port
}

# git checkout PR
gitcpr() {
  [[ -z $1 ]] && echo "Need to specify a PR number" >&2 && return 1
  branch_name="${2:-pr-$1}"
  git fetch origin pull/$1/head:$branch_name
  git checkout $branch_name
  echo "Checked out PR#$1 in $branch_name"
}

gitup() {
  branch="${1:-$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')}"
  remote="${2:-origin}"
  echo "Checking out $branch (\$1) and syncing with $remote (\$2)..." >&2
  git checkout $branch && git pull $remote $branch
}

makemusic() {
  if ! test -d /Volumes/Portable ; then
    echo "You need to plug in the hard drive to store recordings"
    return 1
  fi
  p="/Volumes/Portable/Primary/Production/Recording"
  d="$(date +%Y.%m.%d)"
  [[ ! -d $p/$d ]] && mkdir $p/$d
  open $p/$d
  open /Applications/Audacity.app
}

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
