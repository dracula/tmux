#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

function slice_loop() {
  local str="$1"
  local start="$2"
  local how_many="$3"
  local len=${#str}

  local result=""

  for ((i = 0; i < how_many; i++)); do
    local index=$(((start + i) % len))
    local char="${str:index:1}"
    result="$result$char"
  done

  echo "$result"
}

function update_playerctl_playback() {
  FORMAT=$(get_tmux_option "@dracula-playerctl-format" "Now playing: {{ artist }} - {{ album }} - {{ title }}")

  playerctl_playback=$(playerctl metadata --format "${FORMAT}")
  msg="${playerctl_playback}"

  len=${#msg}
}

main() {
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)

  if ! command -v playerctl &>/dev/null; then
    exit 1
  fi

  update_playerctl_playback
  window_size=25 # Number of characters to display at once
  begin=0

  while true; do
    # Check if playerctl metadata command is available
    if ! command -v playerctl metadata &>/dev/null; then
      echo ""
      exit 1
    fi

    # Slice the message to display
    if [ "$len" -le "$window_size" ]; then
      # If msg length is smaller than window_size, display the entire msg
      slice="$msg"
    else
      slice=$(slice_loop "$msg" $begin $window_size)
    fi

    echo -ne " \r"
    echo -n "$slice"
    echo -ne "\r"
    sleep 0.1

    ((begin++))

    # Check if playerctl_playback has changed
    updated_msg=$(playerctl metadata --format "${FORMAT}")
    updated_msg="$updated_msg "

    if [ "$updated_msg" != "$playerctl_playback" ]; then
      playerctl_playback="$updated_msg"
      msg="$playerctl_playback"
      len=${#msg}
      begin=0
      sleep 1
    fi
  done

}

# run the main driver
main
