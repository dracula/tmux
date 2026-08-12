#!/usr/bin/env bash

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -gqv "$option")"
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

get_tmux_window_option() {
  local option="$1"
  local default_value="$2"
  local option_value="$(tmux show-window-options -v "$option")"
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

# Print the current path of the active pane of session $1.
# Without $1, tmux picks an arbitrary session, possibly the wrong one.
get_pane_dir() {
  local target=()
  [ -n "$1" ] && target=(-t "$1")
  tmux list-panes "${target[@]}" -F "#{pane_active} #{pane_current_path}" 2>/dev/null | while read -r active dir; do
    if [ "$active" == "1" ]; then
      echo "$dir"
      return
    fi
  done
}

# normalize the percentage string to always have a length of 5
normalize_percent_len() {
  # the max length that the percent can reach, which happens for a two digit number with a decimal house: "99.9%"
  max_len=5
  percent_len=${#1}
  let diff_len=$max_len-$percent_len
  # if the diff_len is even, left will have 1 more space than right
  let left_spaces=($diff_len+1)/2
  let right_spaces=($diff_len)/2
  printf "%${left_spaces}s%s%${right_spaces}s\n" "" $1 ""
}

