#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

# configuration
# @dracula-ping-server "example.com"
# @dracula-ping-rate 5

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

ping_function() {
  case $(uname -s) in
  Linux | Darwin)
    # storing the hostname/IP in the variable PINGSERVER, default is google.com
    pingserver=$(get_tmux_option "@dracula-ping-server" "google.com")
    pingtime=$(ping -c 1 "$pingserver" | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
    # Truncate the integer part
    # Network ping doesn't always stable, so keep min length to 5(999ms).
    normalize_string_length "${pingtime%.*}ms" 5
    ;;

  CYGWIN* | MINGW32* | MSYS* | MINGW*)
    # TODO - windows compatability
    ;;
  esac
}

main() {

  # Label Ref           
  ping_label=$(get_tmux_option "@dracula-ping-label" "Ping")
  echo "$ping_label $(ping_function)"

  RATE=$(get_tmux_option "@dracula-ping-rate" 5)
  sleep $RATE
}

# run main driver
main
