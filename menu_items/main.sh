#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

source "$ROOT_DIR/scripts/utils.sh"

get_plugin_title() {
  local plugin=$1
  local active_plugins=$(get_tmux_option "@kanagawa-plugins" "")
  if [[ $active_plugins == *"$plugin"* ]]; then
    echo "Hide $plugin"
  else
    echo "Show $plugin"
  fi
}

render() {
  tmux display-menu -T "#[align=centre fg=green]Main" -x R -y P \
    "" \
    "" \
    "Colors" 1 "run -b 'source #{@kanagawa-root}/menu_items/colors.sh" \
    "Plugins" 2 "run -b 'source #{@kanagawa-root}/menu_items/plugins.sh" \
    "Options" 3 "run -b 'source #{@kanagawa-root}/menu_items/options.sh" \
    "" \
    "Close menu" q ""
}

render
