#!/bin/bash

function start_check() {

    color_normal="\033[0m"; color_black="\033[30m"; 
    bg_green='\033[42m'; bg_red='\033[41m'; bg_yellow='\033[43m'; bg_blue='\033[44m'; bg_magenta='\033[0;45m'; bg_cyan='\033[0;46m'

    function echo_green { echo -e "${bg_green}${color_black}$1${color_normal}${color_normal}"; }
    function echo_red { echo -e "${bg_red}${color_black}$1${color_normal}"; }
    function echo_blue { echo -e "${bg_blue}${color_black}$1${color_normal}"; }
    function echo_magenta { echo -e "${bg_magenta}${color_black}$1${color_normal}"; }

    _DIR=${1/.git/}
    cd $_DIR

    if [[ $_DIR == *"__archive"* ]] || [[ $_DIR == *".terraform"* ]] || [[ $_DIR == *"vendor"* ]]; then
        return
    fi
    
    echo 
    echo 
    echo "---------------------------------------------------------------------------------------------"
    echo "DIR:              ${_DIR}"
    echo "CURRENT BRANCH:   $(git rev-parse --abbrev-ref HEAD)"
    echo "CURRENT HASH:     $(git rev-parse HEAD)"
    echo "REMOTE URL:       $(git config --get remote.origin.url)"
    echo
    git remote update
   
    echo 

    UPSTREAM="@{u}"                                     #UPSTREAM=${1:-'@{u}'}
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @ "$UPSTREAM")

    if [ $LOCAL = $REMOTE ]; then
        echo_green " STATUS:     UP-TO-DATE             "
    elif [ $LOCAL = $BASE ]; then
        echo_magenta " STATUS:     NEED TO PULL         "
    elif [ $REMOTE = $BASE ]; then
        echo_blue " STATUS:     NEED TO PUSH            "
    else
        echo_red " STATUS:     DIVERGED                 "
    fi


}

export -f start_check
find ${1:-.} -name .git -type d -exec bash -c 'start_check "$0"' {} \;