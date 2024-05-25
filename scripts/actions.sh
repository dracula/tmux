#!/usr/bin/env bash

# Should be called from tmux with `run -b` command

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/state.sh"
source "$CURRENT_DIR/utils.sh"

set_state_and_tmux_option() {
  local option=$1
  local value=$2

  tmux set-environment -g "@kanagawa-$option" "$value"
  write_option_to_state "@kanagawa-$option" "$value"
  source "$CURRENT_DIR/kanagawa.sh"
}

toggle_plugin() {
  local plugin=$1
  local active_plugins=$(get_tmux_option "@kanagawa-plugins" "")

  if [[ $active_plugins == *"$plugin"* ]]; then
    # TODO: trim redundant spaces
    new_active_plugins=$(echo $active_plugins | sed -E "s/$plugin//")
  else
    new_active_plugins="$active_plugins $plugin"
  fi

  set_state_and_tmux_option "plugins" "$new_active_plugins"
  source "$CURRENT_DIR/kanagawa.sh"
}

if [ "$1" = "set_state_and_tmux_option" ]; then
  set_state_and_tmux_option "$2" "$3"
elif [ "$1" = "toggle_plugin" ]; then
  toggle_plugin "$2"
fi
