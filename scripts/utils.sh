#!/usr/bin/env bash

get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z "$option_value" ]; then
    echo $default_value
  else
    echo $option_value
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

