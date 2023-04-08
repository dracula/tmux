#!/usr/bin/env bash

# return current working directory of tmux pane
getPaneDir()
{
  nextone="false"
  for i in $(tmux list-panes -F "#{pane_active} #{pane_current_path}");
  do
    if [ "$nextone" == "true" ]; then
      echo $i
      return
    fi 
    if [ "$i" == "1" ]; then
      nextone="true"
    fi
  done
}

main()
{
  path=$(getPaneDir)

  # change '/home/user' to '~'
  cwd=$(echo $path | sed "s;$HOME;~;g")

  echo $cwd
}

#run main driver program
main
