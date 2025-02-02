#!/usr/bin/env bash

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

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

  # check max number of subdirs to display. 0 means unlimited
  cwd_len=$(get_tmux_option "@dracula-cwd-length" "0")

  if [[ "$cwd_len" -gt 0 ]]; then
    base_to_erase=$cwd
    for ((i = 0 ; i < cwd_len ; i++)); do
      base_to_erase="${base_to_erase%/*}"
    done
    # / would have #base_to_erase of 0 and ~/ has #base_to_erase of 1. we want to exclude both cases
    if [[ ${#base_to_erase} -gt 1 ]]; then
      cwd=${cwd:${#base_to_erase}+1}
    fi
  fi

  echo "$cwd"
}

#run main driver program
main
