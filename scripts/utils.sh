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

# normalize the percentage string to customize length and align
# $1 percentage string
# $2 max length, default is 3 (99%)
# $3 align (left, center, right), default is right
normalize_string_length() {
  # the max length that the percent can reach, which happens for a two digit number with a decimal house: "99.9%".
  percent_len=${#1}
  max_len=${2:-5}  # default
  align=${3:-'right'}
  let diff_len=$max_len-$percent_len
  case $align in
    'center')
      # if the diff_len is even, left will have 1 more space than right
      let left_spaces=($diff_len+1)/2
      let right_spaces=($diff_len)/2;;
    'left')
      let left_spaces=0
      let right_spaces=$diff_len;;
    'right')
      let left_spaces=$diff_len
      let right_spaces=0;;
  esac

  printf "%${left_spaces}s%s%${right_spaces}s\n" "" $1 ""
}

