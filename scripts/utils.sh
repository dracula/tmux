#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/state.sh"

get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  local state_option_value=$(read_option_from_state "$option")

  if [ ! -z "$state_option_value" ]; then
    echo $state_option_value
  elif [ ! -z "$option_value" ]; then
    echo $option_value
  else
    echo $default_value
  fi
}

get_tmux_window_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-window-options -v "$option")
  if [ ! -z "$option_value" ]; then
    echo $option_value
  else
    echo $default_value
  fi
}

# normalize the percentage string to always have a length of 5
normalize_percent_len() {
  # the max length that the percent can reach, which happens for a two digit number with a decimal house: "99.9%"
  max_len=5
  percent_len=${#1}
  let diff_len=$max_len-$percent_len
  # if the diff_len is even, left will have 1 more space than right
  let left_spaces=($diff_len + 1)/2
  let right_spaces=($diff_len)/2
  printf "%${left_spaces}s%s%${right_spaces}s\n" "" $1 ""
}
