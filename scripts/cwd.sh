#!/usr/bin/env bash

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$current_dir/utils.sh"

# return current working directory of tmux pane
getPaneDir() {
  local session="$1"
  if [ -n "$session" ]; then
    tmux list-panes -t "$session" -f '#{pane_active}' -F "#{pane_current_path}" 2>/dev/null
  else
    tmux list-panes -f '#{pane_active}' -F "#{pane_current_path}" 2>/dev/null
  fi
}

main() {
  path="$(getPaneDir "$1")"

  if [[ "$path" == "$HOME" ]]; then
    echo "~"
    exit 0
  fi

  # change '/home/user' to '~'
  cwd="${path#"$HOME"}"
  cwd="~${cwd}"

  # check max number of subdirs to display. 0 means unlimited
  cwd_max_dirs="$(get_tmux_option "@dracula-cwd-max-dirs" "0")"

  if [[ "$cwd_max_dirs" -gt 0 ]]; then
    base_to_erase=$cwd
    for ((i = 0 ; i < cwd_max_dirs ; i++)); do
      base_to_erase="${base_to_erase%/*}"
    done
    # / would have #base_to_erase of 0 and ~/ has #base_to_erase of 1. we want to exclude both cases
    if [[ ${#base_to_erase} -gt 1 ]]; then
      cwd="…/${cwd:${#base_to_erase}+1}"
    fi
  fi

  cwd_max_chars="$(get_tmux_option "@dracula-cwd-max-chars" "0")"
  if [[ "${cwd_max_chars}" -gt 0 && "${#cwd}" -gt "$cwd_max_chars" ]]; then
    cwd="…/…${cwd:(- cwd_max_chars)}"
  fi

  echo "$cwd"
}

#run main driver program
main "$@"
