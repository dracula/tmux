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

# Create a slice of the text to show currently in the module
# arg1: The full string
# arg2: Where to start the loop from
# arg3: The length of characters to display
slice_text() {
  local str="$1"
  local start="$2"
  local how_many="$3"

  local len=${#str}

  local result=""

  # Caputre the strings to show
  for ((i = 0; i < how_many; i++)); do
    local index=$(((start + i) % len))
    local char="${str:index:1}"

    # Append the character to show
    result="$result$char"
  done

  echo "$result"
}
