#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

main()
{
  uptime_label=$(get_tmux_option "@dracula-uptime-label" "UP")
  uptime=$(uptime | awk -F' up ' '{ split($2,a,","); printf "%s", a[1] }')
  echo "$uptime_label $uptime"
}

main
