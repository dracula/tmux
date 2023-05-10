#!/usr/bin/env bash

# return current working directory of tmux pane
getPaneDir()
{
    nextone="false"
    ret=""
    for i in $(tmux list-panes -F "#{pane_active} #{pane_current_path}");
    do
        [ "$i" == "1" ] && nextone="true" && continue
        [ "$i" == "0" ] && nextone="false"
        [ "$nextone" == "true" ] && ret+="$i "
    done
    echo "${ret%?}"
}

source "$HOME/.vim/buf"

path="$vim_buf"
[ -z "$path" ] && path=$(getPaneDir)

# change '/home/user' to '~'
echo "${path/"$HOME"/'~'}"
