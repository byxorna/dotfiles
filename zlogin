# launch tmux session if we arent already inside one, and tmux is installed
# dont do anything unless we are not inside tmux AND not in an ssh tty.
# (i.e. dont launch tmux remotely by default)
if [[ -z $TMUX && -z $SSH_TTY ]] ; then
  if type -p tmux &>/dev/null ; then
    if tmux ls ; then
      # attach to whatever first session is available to us by default
      tmux attach-session -t 0
    else
      # create a new session
      tmux new
    fi
  fi
fi
