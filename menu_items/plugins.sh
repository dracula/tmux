#!/usr/bin/env bash

CURRENT_FILE="${BASH_SOURCE[0]}"
CURRENT_DIR="$(dirname -- "$(readlink -f -- "$0")")"
ROOT_DIR="$(dirname "$CURRENT_DIR")"

source "$ROOT_DIR/scripts/utils.sh"

available_plugins="battery cpu-usage git gpu-usage ram-usage tmux-ram-usage network network-bandwidth network-ping ssh-session attached-clients network-vpn weather time mpc spotify-tui playerctl kubernetes-context synchronize-panes"

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
  tmux display-menu -T "#[align=centre fg=green]Plugins" -x R -y P \
    "" \
    "" \
    "$(get_plugin_title "battery")" A "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin battery; source $CURRENT_FILE" \
    "$(get_plugin_title "cpu-usage")" B "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin cpu-usage; source $CURRENT_FILE" \
    "$(get_plugin_title "git")" C "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin git; source $CURRENT_FILE" \
    "$(get_plugin_title "gpu-usage")" D "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin gpu-usage; source $CURRENT_FILE" \
    "$(get_plugin_title "ram-usage")" E "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin ram-usage; source $CURRENT_FILE" \
    "$(get_plugin_title "tmux-ram-usage")" F "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin tmux-ram-usage; source $CURRENT_FILE" \
    "$(get_plugin_title "network")" G "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin network; source $CURRENT_FILE" \
    "$(get_plugin_title "network-bandwidth")" H "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin network-bandwidth; source $CURRENT_FILE" \
    "$(get_plugin_title "network-ping")" I "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin network-ping; source $CURRENT_FILE" \
    "$(get_plugin_title "ssh-session")" J "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin ssh-session; source $CURRENT_FILE" \
    "$(get_plugin_title "attached-clients")" K "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin attached-clients; source $CURRENT_FILE" \
    "$(get_plugin_title "network-vpn")" L "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin network-vpn; source $CURRENT_FILE" \
    "$(get_plugin_title "weather")" M "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin weather; source $CURRENT_FILE" \
    "$(get_plugin_title "time")" N "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin time; source $CURRENT_FILE" \
    "$(get_plugin_title "mpc")" O "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin mpc; source $CURRENT_FILE" \
    "$(get_plugin_title "spotify-tui")" P "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin spotify-tui; source $CURRENT_FILE" \
    "$(get_plugin_title "playerctl")" Q "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin playerctl; source $CURRENT_FILE" \
    "$(get_plugin_title "kubernetes-context")" R "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin kubernetes-context; source $CURRENT_FILE" \
    "$(get_plugin_title "synchronize-panes")" S "run -b 'source #{@kanagawa-root}/scripts/actions.sh toggle_plugin synchronize-panes; source $CURRENT_FILE" \
    "" \
    "<-- Back" b "run -b 'source #{@kanagawa-root}/menu_items/main.sh" \
    "Close menu" q ""
}

render
