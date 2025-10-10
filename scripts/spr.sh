#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/utils.sh"


trackStatus() {
  local pause_icon="$1" play_icon="$2"
	local track_info playback status track_result

  playback=$(spotify_player get key playback)


  status=$(echo "$playback" | jq -r '.["is_playing"]')
  track_info=$(echo "$playback" | jq -r '.item | "\(.artists | map(.name) | join(", ")) - \(.name)"')
  track_result=""

  if [[ $status == "true" ]]; then
    track_result+=$play_icon
    track_result+=$track_info
  else
    track_result+=$pause_icon
    track_result+=$track_info
  fi

case "$status" in
		"null") echo "spotify not running" ;;
		*) echo "$track_result" ;;
	esac

}

function sliceTrack()
{
  local str="$1"
  local std="$2"
  local len=${#str}

  local result=""

  if [[ $len > $std ]]; then
    result="${str:0:$std}"
    result+="..."
  else
    result=$str
  fi

  echo "$result"
}


function sprRemoteControl() {
  local toggle_button="$1"
  local back_button="$2"
  local next_button="$3"

  local toggle="spotify_player playback play-pause > /dev/null 2>&1"
  local back="spotify_player playback previous > /dev/null 2>&1"
  local next="spotify_player playback next > /dev/null 2>&1"


  tmux unbind-key "$toggle_button" 2>/dev/null
  tmux unbind-key "$back_button" 2>/dev/null
  tmux unbind-key "$next_button" 2>/dev/null

  tmux bind-key "$toggle_button" run-shell "$toggle"
  tmux bind-key "$back_button" run-shell "$back"
  tmux bind-key "$next_button" run-shell "$next"

}

main() {
  # save buffer to prevent lag
  local cache_file="/tmp/tmux_spr_cache"

  RATE="$(get_tmux_option "@dracula-refresh-rate" 5)"

  MAX_LENGTH="$(get_tmux_option "@dracula-spr-length" 25)"

  # Remote Control checker
  SPR_REMOTE_ACCESS="$(get_tmux_option "@dracula-spr-remote" "false")"

  PLAY_ICON=$(get_tmux_option "@dracula-spr-play-icon" "♪ ")
  PAUSE_ICON=$(get_tmux_option "@dracula-spr-pause-icon" "❚❚ ")


  if ! command -v spotify_player &> /dev/null
  then
    exit 1
  fi

  # Remote Access
  if [[ "$SPR_REMOTE_ACCESS" == "true" ]]; then
    PLAY_PAUSE_BUTTON=$(get_tmux_option "@dracula-spr-remote-play-pause" "P")
    BACK_BUTTON=$(get_tmux_option "@dracula-spr-remote-back" "R")
    NEXT_BUTTON=$(get_tmux_option "@dracula-spr-remote-next" "N")
    sprRemoteControl "$PLAY_PAUSE_BUTTON" "$BACK_BUTTON" "$NEXT_BUTTON"
  else
    tmux set -g @dracula-spr-remote-play-pause ""
    tmux set -g @dracula-spr-remote-back ""
    tmux set -g @dracula-spr-remote-next ""
    tmux unbind-key "$PLAY_PAUSE_BUTTON" 2>/dev/null
    tmux unbind-key "$BACK_BUTTON" 2>/dev/null
    tmux unbind-key "$NEXT_BUTTON" 2>/dev/null
  fi


  if [ ! -f "$cache_file" ] || [ $(($(date +%s) - $(stat -c%Y "$cache_file" 2>/dev/null || stat -f%m "$cache_file"))) -ge "$RATE" ]; then
    local full_track
    full_track=$(trackStatus "$PAUSE_ICON" "$PLAY_ICON")
    sliceTrack "$full_track" "$MAX_LENGTH" > "$cache_file"
  fi

  cat "$cache_file"
}

main

