#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

# set your own hosts so that a wifi is recognised even without internet access
HOSTS=$(get_tmux_option "@dracula-network-hosts" "google.com github.com example.com")

get_ssid()
{
  # Check OS
  case $(uname -s) in
    Linux)
      SSID=$(iw dev | sed -nr 's/^\t\tssid (.*)/\1/p')
      if [ -n "$SSID" ]; then
        printf '%s' "$wifi_label$SSID"
      else
        echo "$(get_tmux_option "@dracula-network-ethernet-label" "Ethernet")"
      fi
      ;;

    Darwin)
      if networksetup -getairportnetwork en0 | cut -d ':' -f 2 | sed 's/^[[:blank:]]*//g' &> /dev/null; then
        wifi_label=$(get_tmux_option "@dracula-network-wifi-label" "")
        echo "$wifi_label$(networksetup -getairportnetwork en0 | cut -d ':' -f 2)" | sed 's/^[[:blank:]]*//g'
      else
        echo "$(get_tmux_option "@dracula-network-ethernet-label" "Ethernet")"
      fi
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # leaving empty - TODO - windows compatability
      ;;

    *)
      ;;
  esac

}

main()
{
  network="$(get_tmux_option "@dracula-network-offline-label" "Offline")"
  for host in $HOSTS; do
    if ping -q -c 1 -W 1 $host &>/dev/null; then
      network="$(get_ssid)"
      break
    fi
  done

  echo "$network"
}

#run main driver function
main
