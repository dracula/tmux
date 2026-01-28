#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

label=$1

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

get_synchronize_panes_status() {
  current_synchronize_panes_status=$(get_tmux_window_option "synchronize-panes" "off")
  echo $current_synchronize_panes_status
}

main()
{
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)

  # Use the @dracula-synchronize-panes-refresh-rate plugin variable to override it.
  RATE_OVERRIDE=$(get_tmux_option "@dracula-synchronize-panes-refresh-rate" "")
  if [[ -n "$RATE_OVERRIDE" ]]; then
    RATE="$RATE_OVERRIDE"
  fi

  synchronize_panes_auto_hide=$(get_tmux_option "@dracula-synchronize-panes-auto-hide" "false")
  synchronize_panes_status=$(get_synchronize_panes_status)
  synchronize_panes_label=$label

  if [[ "$synchronize_panes_auto_hide" == 'true' ]]; then
    if [[ "$synchronize_panes_status" == 'on' ]]; then
      echo "$synchronize_panes_label"
    fi
  else
    echo "$synchronize_panes_label $synchronize_panes_status"
  fi

  sleep $RATE
}

# run main driver
main
