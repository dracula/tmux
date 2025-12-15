#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

# set your own hosts so that a wifi is recognised even without internet access
HOSTS=$(get_tmux_option "@dracula-network-hosts" "google.com github.com example.com")
wifi_label=$(get_tmux_option "@dracula-network-wifi-label" "")
ethernet_label=$(get_tmux_option "@dracula-network-ethernet-label" "Ethernet")

_get_wifi_ifname() {
  if ! scutil <<< list |
    awk -F/ '/Setup:.*AirPort$/{i=$(NF-1);exit} END {if(i) {print i} else {exit 1}}'; then
    scutil <<< list | awk -F/ '/en[0-9]+\/AirPort$/ {print $(NF-1);exit}'
  fi
}

get_ssid()
{
  # Check OS
  case $(uname -s) in
    Linux)
      SSID=$(iw dev | sed -nr 's/^\t\tssid (.*)/\1/p')
      if [ -n "$SSID" ]; then
        echo "$wifi_label$SSID"
      else
        echo "$ethernet_label"
      fi
      ;;

    Darwin)
      local ifname
      local wifi_network
      local airport

      ifname=$(_get_wifi_ifname)

      if (( $(echo "$(sw_vers -productVersion) > 25.0" | bc -l) )); then
        wifi_network=$(networksetup -listpreferredwirelessnetworks "$ifname" | awk 'NR==2 && sub("\t","") { print; exit }')
      else
        wifi_network=$(ipconfig getsummary "$ifname" | awk -F ' SSID : '  '/ SSID : / {print $2}')
      fi

      airport=$(networksetup -getairportnetwork "$ifname" | cut -d ':' -f 2 | head -n 1)

      airport=$(echo "$airport" | sed 's/^[[:blank:]]*//g')
      if [[ $airport != "You are not associated with an AirPort network." ]]; then
        echo "$wifi_label$airport" | sed 's/^[[:blank:]]*//g'
      elif [[ $wifi_network != "" ]]; then
        echo "$wifi_label$wifi_network" | sed 's/^[[:blank:]]*//g'
      else
        echo "$ethernet_label"
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
    if ping -q -c 1 -W 1 "$host" &>/dev/null; then
      network="$(get_ssid)"
      break
    fi
  done

  echo "$network"
}

#run main driver function
main
