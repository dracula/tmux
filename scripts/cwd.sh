#!/usr/bin/env bash

# return current working directory of tmux pane
getPaneDir() {
  nextone="false"
  ret=""
  for i in $(tmux list-panes -F "#{pane_active} #{pane_current_path}"); do
    [ "$i" == "1" ] && nextone="true" && continue
    [ "$i" == "0" ] && nextone="false"
    [ "$nextone" == "true" ] && ret+="$i "
  done
  echo "${ret%?}"
}

main() {
  path=$(getPaneDir)

  # change '/home/user' to '~'
  cwd="${path/"$HOME"/'~'}"

  # check if the user wants only the current directory
  basename_enabled=$(tmux show-option -gqv @dracula-cwd-basename)

  if [ "$basename_enabled" == "true" ]; then
    #Extract only the last part of path
    cwd=$(basename "$cwd")
  fi

  echo "$cwd"
}

#run main driver program
main
