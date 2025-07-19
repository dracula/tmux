#!/usr/bin/env bash

export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$current_dir/utils.sh"


function trackStatus() {
	local active_player
  local pause_icon="$1"
  local play_icon="$2"

	active_player=$(osascript -e "
	property playerList : {\"Spotify\", \"Music\", \"Safari\", \"Google Chrome\"}
	property nativePlayerList : {\"Spotify\", \"Music\"}


  -- Detect the Player being used
	on detectPlayer()
		repeat with appName in playerList
			set currentApp to contents of appName
      -- process checker
      -- native and browser checker
			if (running of application currentApp) then
				if (currentApp is not in nativePlayerList) then
					return browserPlayer(currentApp)
				else
					return nativePlayer(currentApp)
				end if
			end if
		end repeat

		return \"No App Supported\"
	end detectPlayer


  -- nativePlayer Function: supports spotify and apple-music
	on nativePlayer(nativeName)
		if not (running of application nativeName) then return \"not running\"
		if nativeName is \"Spotify\" then
			tell application \"Spotify\"
				if player state is stopped then return \"stopped\"
				set trackArtist to artist of current track
				set trackName to name of current track
				if player state is paused then
					return \"$pause_icon \" & trackArtist & \" - \" & trackName
				else
			return \"$play_icon \" & trackArtist & \" - \" & trackName
				end if

			end tell
		else if nativeName is \"Music\" then
			tell application \"Music\"
				if player state is stopped then return \"stopped\"
				set trackArtist to artist of current track
				set trackName to name of current track
				if player state is paused then
					return \"$pause_icon \" & trackArtist & \" - \" & trackName
				else
			return \"$play_icon \" & trackArtist & \" - \" & trackName
				end if

			end tell
		end if

	end nativePlayer

  -- browserPlayer Function: supports Safari and Google Chrome
	on browserPlayer(browserName)
		if (running of application \"Safari\") and (browserName is \"Safari\") then
			tell application \"Safari\"
				set currentTab to the front document
				set currentURL to URL of currentTab
				set pageTitle to name of currentTab
			end tell
		else if (running of application \"Google Chrome\") and (browserName is \"Google Chrome\") then
			tell application \"Google Chrome\"
				set currentTab to active tab of front window
				--- set currentTab to active tab of front window
				set currentURL to URL of currentTab
				set pageTitle to title of currentTab
			end tell
		else
			return \"Not Supported\"
		end if


		-- Check if it's a YouTube video page
		if currentURL contains \"youtube.com/watch\" then
			-- YouTube video titles usually follow this format: \"Artist - Track Name\"
			set AppleScript's text item delimiters to \" - \"
			set titleParts to text items of pageTitle

			if (count of titleParts) ≥ 2 then
				set artistName to item 1 of titleParts
				set trackName to item 2 of titleParts
				--- display dialog \"Artist: \" & artistName & return & \"Track: \" & trackName
				return artistName & \" - \" & trackName
			else
				--- display dialog \"Could not parse artist and track from: \" & pageTitle
				return \"can't encode\"
			end if
			-- Check if it's a Spotify video page
		else if currentURL contains \"open.spotify.com\" then
			-- Spotify video titles usually follow this format: \"Artist • Track Name\"
			set AppleScript's text item delimiters to \" • \"
			set titleParts to text items of pageTitle

			if (count of titleParts) ≥ 2 then
				set artistName to item 1 of titleParts
				set trackName to item 2 of titleParts
				--- display dialog \"Artist: \" & artistName & return & \"Track: \" & trackName
				return artistName & \" - \" & trackName
			else
				--- display dialog \"Could not parse artist and track from: \" & pageTitle
				return \"can't encode\"
			end if


		else
			return \"No active Tab\"
		end if

	end browserPlayer


	detectPlayer()
	")


case "$active_player" in
		"not running") echo "not running" ;;
		"stopped") echo "stopped" ;;
    "can't encode") echo "unable to encode" ;;
    "Not Supported") echo "not supported" ;;

		*) echo "$active_player" ;;
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


function remoteControl() {
  local toggle_button="$1"
  local back_button="$2"
  local next_button="$3"
  local app_controlled="$4"

  if [[ $app_controlled == "Spotify" ]] || [[ $app_controlled == "Music" ]]; then

    if [[ $app_controlled == "Music" ]]; then
      back="osascript -e 'tell application \"$app_controlled\" to back track'"
    else
      back="osascript -e 'tell application \"$app_controlled\" to previous track'"
    fi

    toggle="osascript -e 'tell application \"$app_controlled\" to playpause'"
    next="osascript -e 'tell application \"$app_controlled\" to play next track'"

    tmux unbind-key "$toggle_button"
    tmux unbind-key "$back_button"
    tmux unbind-key "$next_button"

    tmux bind-key "$toggle_button" run-shell "$toggle"
    tmux bind-key "$back_button" run-shell "$back"
    tmux bind-key "$next_button" run-shell "$next"
  fi
}


main() {
  # save buffer to prevent lag
	local cache_file="/tmp/tmux_mac_player_cache"

  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)

  # Active Player variables
  PLAY_ICON=$(get_tmux_option "@dracula-mac-player-play-icon" "♪")
  PAUSE_ICON=$(get_tmux_option "@dracula-mac-player-pause-icon" "❚❚ ")
  MAX_LENGTH=$(get_tmux_option "@dracula-mac-player-length" 25)

  # Remote variables
  REMOTE_ACCESS=$(get_tmux_option "@dracula-mac-player-remote" "false")
  REMOTE_APP=$(get_tmux_option "@dracula-mac-player-app" "Spotify")

  # os checker
  if [[ "$OSTYPE" != "darwin"* ]]; then
    exit 1
  fi

  # Remote Access
  if [[ "$REMOTE_ACCESS" == "true" ]]; then
    # Remote Control Buttons Customizations
    PLAY_PAUSE_BUTTON=$(get_tmux_option "@dracula-mac-player-remote-play-pause" "P")
    BACK_BUTTON=$(get_tmux_option "@dracula-mac-player-remote-back" "R")
    NEXT_BUTTON=$(get_tmux_option "@dracula-mac-player-remote-next" "N")

    remoteControl "$PLAY_PAUSE_BUTTON" "$BACK_BUTTON" "$NEXT_BUTTON" "$REMOTE_APP"
  else
    # Clean up when remote is disabled
    tmux set -g @dracula-mac-player-remote-play-pause ""
    tmux set -g @dracula-mac-player-remote-back ""
    tmux set -g @dracula-mac-player-remote-next ""
    tmux unbind-key "$PLAY_PAUSE_BUTTON" 2>/dev/null
    tmux unbind-key "$BACK_BUTTON" 2>/dev/null
    tmux unbind-key "$NEXT_BUTTON" 2>/dev/null
  fi

  if [ ! -f "$cache_file" ] || [ $(($(date +%s) - $(stat -f%c "$cache_file"))) -ge "$RATE" ]; then
    local full_track

    full_track=$(trackStatus "$PAUSE_ICON" "$PLAY_ICON")
    sliceTrack "$full_track" "$MAX_LENGTH" > "$cache_file"
  fi

	cat "$cache_file"
}

main

