#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

# configuration
# @kanagawa-ping-server "example.com"
# @kanagawa-ping-rate 5

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

ping_function() {
  case $(uname -s) in
  Linux | Darwin)
    # storing the hostname/IP in the variable PINGSERVER, default is google.com
    pingserver=$(get_tmux_option "@kanagawa-ping-server" "google.com")
    pingtime=$(ping -c 1 "$pingserver" | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
    echo "$pingtime ms"
    ;;

  CYGWIN* | MINGW32* | MSYS* | MINGW*)
    # TODO - windows compatability
    ;;
  esac
}

main() {

  echo $(ping_function)
  RATE=$(get_tmux_option "@kanagawa-ping-rate" 5)
  sleep $RATE
}

# run main driver
main
