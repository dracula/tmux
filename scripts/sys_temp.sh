#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

get_temp() {
  if grep -q "Raspberry" /proc/device-tree/model 2>/dev/null; then
    # It's a Raspberry pi
    echo "$(vcgencmd measure_temp | sed 's/temp=//')"
  else
    echo "$(sensors | grep 'Tctl' | awk '{print substr($2, 2)}')"
  fi
}

main() {
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  echo "$(get_temp)"
  sleep $RATE
}

# run main driver
main
