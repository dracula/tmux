#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

# Set the configuration

# Scroll the text
# arg1: text
# arg2: width
# arg3: speed
scroll() {
  local str=$1
  local width=$2
  local speed=$2

  local scrolling_text=""
  local i=0
  local len=${#str}

  for ((i = 0; i <= len; i++)); do
    scrolling_text=$(slice_text "$str" "$i" "$width")
    echo -ne "\r"
    echo "$scrolling_text "
    echo -ne "\r"

    sleep "$speed"
  done

  echo -ne "\r"
  echo "$scrolling_text "
  echo -ne "\r"
}

main() {
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)

  if ! command -v playerctl &>/dev/null; then
    exit 1
  fi

  FORMAT=$(get_tmux_option "@dracula-playerctl-format" "Now playing: {{ artist }} - {{ album }} - {{ title }}")
  SCROLL=$(get_tmux_option "@dracula-playerctl-scroll" true)
  WIDTH=$(get_tmux_option "@dracula-playerctl-width" 25)
  SPEED=$(get_tmux_option "@dracula-playerctl-speed" 0.08)

  playerctl_playback=$(playerctl metadata --format "${FORMAT}")
  playerctl_playback="${playerctl_playback} "

  # Initial start point for scrolling
  start=0
  len=${#playerctl_playback}

  # previously we have appended a space to playerctl_playback
  # if there is no player, len sees only one space
  # exit the script and output nothing if there is just that space
  if [[ $len == 1 ]]; then
    exit
  fi

  scrolling_text=""

  if [ "$SCROLL" = true ]; then
    scroll "$playerctl_playback" "$WIDTH" "$SPEED"
  else
    echo "$playerctl_playback"
  fi
}

# run the main driver
main
