
# gdate for macOS
# REF: https://apple.stackexchange.com/questions/135742/time-in-milliseconds-since-epoch-in-the-terminal
if [[ "$OSTYPE" == "darwin"* ]]; then
    {
        gdate
    } || {
        echo "\n$fg_bold[yellow]passsion.zsh-theme depends on cmd [gdate] to get current time in milliseconds$reset_color"
        echo "$fg_bold[yellow][gdate] is not installed by default in macOS$reset_color"
        echo "$fg_bold[yellow]to get [gdate] by running:$reset_color"
        echo "$fg_bold[green]brew install coreutils;$reset_color";
        echo "$fg_bold[yellow]\nREF: https://github.com/ChesterYue/ohmyzsh-theme-passion#macos\n$reset_color"
    }
fi

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

# time
function real_time() {
    local color="%{$BLUE%}";
    local time="[$(date +%H:%M:%S)]";
    local color_reset="%{$reset_color%}";
    echo "${color}${time}${color_reset}";
}


# directory
function directory() {
    local color="%{$fg_no_bold[cyan]%}";
    #local color="%{$ORANGE%}";
    # REF: https://stackoverflow.com/questions/25944006/bash-current-working-directory-with-replacing-path-to-home-folder
    local directory="${PWD/#$HOME/~}";
    # https://unix.stackexchange.com/questions/273529/shorten-path-in-zsh-prompt
    #local d="%(4~|%-1~/…/%2~|%3~)"
    #local d="%(6~|%-1~/%-2~/%-3~/…/%5~|%3~)"
    #local directory="${d/#$HOME/~}";
    local color_reset="%{$reset_color%}";
    echo "${color}${directory}${color_reset}";
}


# git
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_no_bold[magenta]%}";
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} ";
ZSH_THEME_GIT_PROMPT_DIRTY="%{$RED%}*";
ZSH_THEME_GIT_PROMPT_CLEAN="%{$BLUE%}";

function update_git_status() {
    GIT_STATUS=$(git_prompt_info);
}

function git_status() {
    echo "${GIT_STATUS}"
}


# command
function update_command_status() {
    local arrow="";
    local color_reset="%{$reset_color%}";
    local reset_font="%{$fg_no_bold[white]%}";
    arrow="%{$fg_bold[blue]%}❱";
    COMMAND_STATUS="${arrow}${reset_font}${color_reset}";
}
update_command_status true;

function command_status() {
    echo "${COMMAND_STATUS}"
}


# output command execute after
output_command_execute_after() {
    if [ "$COMMAND_TIME_BEIGIN" = "-20200325" ] || [ "$COMMAND_TIME_BEIGIN" = "" ];
    then
        return 1;
    fi

    # show previous command
    local cmd="${$(fc -l | tail -1|tr -s ' '|cut -d ' ' -f2-)#*  }";
    local color_cmd="";
    # color previous command based on success
    if $1;
    then
        color_cmd="$fg_no_bold[white]";
        #color_cmd="$BASE02"
    else
        color_cmd="$fg_bold[red]";
    fi
    local color_reset="$reset_color";
    cmd="${color_cmd}# ${cmd}${color_reset}"

    # time
    local time="[$(date +%H:%M:%S)]"
    local color_time="$BASE00";
    time="${color_time}${time}${color_reset}";

    # compute delta cost
    local time_end="$(current_time_millis)";
    local cost=$(bc -l <<<"${time_end}-${COMMAND_TIME_BEIGIN}");
    COMMAND_TIME_BEIGIN="-20200325"
    local length_cost=${#cost};
    if [ "$length_cost" = "4" ];
    then
        cost="0${cost}"
    fi
    cost="Δ${cost}s"
    local color_cost="$BASE01";
    cost="${color_cost}${cost}${color_reset}";

    echo -e "";
    echo -e "${time} ${cost} ${cmd}";
}


# command execute before
# REF: http://zsh.sourceforge.net/Doc/Release/Functions.html
preexec() {
    COMMAND_TIME_BEIGIN="$(current_time_millis)";
}

current_time_millis() {
    local time_millis;
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        # Linux
        time_millis="$(date +%s.%3N)";
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        time_millis="$(gdate +%s.%3N)";
    elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
    elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
    elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
    else
        # Unknown.
    fi
    echo $time_millis;
}


# command execute after
# REF: http://zsh.sourceforge.net/Doc/Release/Functions.html
precmd() {
    # last_cmd
    local last_cmd_return_code=$?;
    local last_cmd_result=true;
    if [ "$last_cmd_return_code" = "0" ];
    then
        last_cmd_result=true;
    else
        last_cmd_result=false;
    fi

    # update_git_status
    update_git_status;

    # update_command_status
    update_command_status $last_cmd_result;

    # output command execute after
    output_command_execute_after $last_cmd_result;
}


# set option
setopt PROMPT_SUBST;


# timer
#REF: https://stackoverflow.com/questions/26526175/zsh-menu-completion-causes-problems-after-zle-reset-prompt
TMOUT=1;
TRAPALRM() {
    # $(git_prompt_info) cost too much time which will raise stutters when inputting. so we need to disable it in this occurence.
    # if [ "$WIDGET" != "expand-or-complete" ] && [ "$WIDGET" != "self-insert" ] && [ "$WIDGET" != "backward-delete-char" ]; then
    # black list will not enum it completely. even some pipe broken will appear.
    # so we just put a white list here.
    if [ "$WIDGET" = "" ] || [ "$WIDGET" = "accept-line" ] ; then
        zle reset-prompt;
    fi
}

display_k8s_context() {
  kc="$(kctx)"
  if [[ -z $kc ]] ; then
    return
  fi
  echo "%{$BLUE%}$kc "
}

# prompt
PROMPT='$(real_time) $(directory) $(display_k8s_context)$(git_status)$(command_status) ';
