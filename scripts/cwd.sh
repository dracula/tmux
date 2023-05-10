#!/usr/bin/env bash

# return current working directory of tmux pane
getPaneDir()
{
    nextone="false"
    for i in $(tmux list-panes -F "#{pane_active} #{pane_current_path}");
    do
        if [ "$nextone" == "true" ]; then
            echo "$i"
            return
        fi
        [ "$i" == "1" ] && nextone="true"
    done
}

source "$HOME/.vim/buf"

path="$vim_buf"
[ -z "$path" ] && path=$(getPaneDir)

# change '/home/user' to '~'
echo "${path/"$HOME"/'~'}"
