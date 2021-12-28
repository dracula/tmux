#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

get_bytes()
{
  case $(uname -s) in
    Linux)
      download=$(cat /sys/class/net/$1/statistics/rx_bytes)
      upload=$(cat /sys/class/net/$1/statistics/tx_bytes)
      echo "$download $upload"
      ;;

    Darwin)
      down_up_load=$(netstat -nI $1 -b | tail -n1 | awk '{print $7,$10}')
      echo "$down_up_load"
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # TODO - windows compatability
      ;;
  esac
}

get_network_name()
{
  case $(uname -s) in
    Linux)
      default_network_name=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")
      echo "$default_network_name"
      ;;

    Darwin)
      default_network_name=$(route -n get default | grep 'interface:' | awk '{print $2}')
      echo "$default_network_name"
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # TODO - windows compatability
      ;;
  esac
}

format_bytes()
{
  if [ $1 -gt 1073741824 ]; then
    format_num=$(echo "$1 1024" | awk '{printf "%.2f \n", $1/($2 * $2 * $2)}')
    echo "$format_num gB/s"
  elif [ $1 -gt 1048576 ]; then
    format_num=$(echo "$1 1024" | awk '{printf "%.2f \n", $1/($2 * $2)}')
    echo "$format_num mB/s"
  else
    format_num=$(echo "$1 1024" | awk '{printf "%.2f \n", $1/$2}')
    echo "$format_num kB/s"
  fi
}

get_bandwidth() {
  read initial_download initial_upload < <(get_bytes $2)

  sleep $1

  read final_download final_upload < <(get_bytes $2)

  total_download_bps=$(echo "$final_download $initial_download $1" | awk '{printf "%.0f \n", ($1 - $2) / $3}')
  total_upload_bps=$(echo "$final_upload $initial_upload $1" | awk '{printf "%.0f \n", ($1 - $2) / $3}')

  output_download=$(format_bytes $total_download_bps)
  output_upload=$(format_bytes $total_upload_bps)

  echo "↓ $output_download • ↑ $output_upload"
}

main()
{
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  default_network_name=$( get_network_name )
  network_name=$(get_tmux_option "@dracula-network-bandwith" "$default_network_name")
  network_bandwidth=$(get_bandwidth "$RATE" "$network_name")
  echo "$network_bandwidth"
}

# run the main driver
main
