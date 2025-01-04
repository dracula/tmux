#!/usr/bin/env bash

# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

main() {
  IP_SERVER="ifconfig.me"
  ip=$(curl -s "$IP_SERVER")

  IP_LABEL=$(get_tmux_option "@dracula-network-public-ip-label" "")
  echo "$IP_LABEL $ip"
}

# run the main driver
main
