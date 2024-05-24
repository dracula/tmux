#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STATE_FILE="$ROOT_DIR/data/.tmux-kanagawa-state"

read_option_from_state() {
  if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
  fi

  local row=$(grep "^$1" "$STATE_FILE")

  echo "$row" | cut -d ' ' -f2-
}

write_option_to_state() {
  if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
  fi

  local option=$1
  local value=$2
  if grep -q "^$option" "$STATE_FILE"; then
    sed -i "" "s/^$option.*/$option $value/" "$STATE_FILE"
  else
    echo "$option $value" >>"$STATE_FILE"
  fi
}

reset_state() {
  if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
  fi

  rm "$STATE_FILE"
  touch "$STATE_FILE"
}
