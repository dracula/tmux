#!/usr/bin/env bash

# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

DATAFILE="/tmp/.dracula-tmux-public-ip-data"
LAST_EXEC_FILE="/tmp/.dracula-tmux-public-ip-last-exec"
INTERVAL=1200

main() {
  local _current_dir _last _now
  current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  _last=$(cat "$LAST_EXEC_FILE" 2>/dev/null || echo 0)
  _now=$(date +%s)

  source $current_dir/utils.sh

  if (((_now - _last) > INTERVAL)); then
    IP_SERVER="ifconfig.me"
    ip=$(curl -s "$IP_SERVER")

    echo "$(get_tmux_option "@dracula-network-public-ip-label" "")$ip" > "${DATAFILE}"
    printf '%s' "$_now" > "${LAST_EXEC_FILE}"
  fi

  cat "${DATAFILE}"
}

# run the main driver
main
