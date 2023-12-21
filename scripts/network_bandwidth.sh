#!/usr/bin/env bash

# INTERVAL is equal to 1s because we want to express the bandwidth in sec
readonly INTERVAL=1

# UPLOAD and DOWNLOAD index
readonly UPLOAD=0
readonly DOWNLOAD=1

# SIZE index are the multiple of the unit byte and value the internationally recommended unit symbol in sec
readonly SIZE=(
  [1]='B/s'
  [1024]='kB/s'
  [1048576]='MB/s'
  [1073741824]='GB/s'
)

# interface_get try to automaticaly get the used interface if network_name is empty
interface_get() {
  name="$(tmux show-option -gqv "@kanagawa-network-bandwidth")"

  if [[ -z $name ]]; then
    case "$(uname -s)" in
    Linux)
      if type ip >/dev/null; then
        name="$(ip -o route get 192.168.0.0 | awk '{print $5}')"
      fi
      ;;
    Darwin)
      if type route >/dev/null; then
        name="$(route -n get 192.168.0.0 2>/dev/null | awk '/interface: / {print $2}')"
      fi
      ;;
    esac
  fi

  echo "$name"
}

# interface_bytes give an interface name and return both tx/rx Bytes, separated by whitespace (upload first)
interface_bytes() {
  case "$(uname -s)" in
  Linux)
    upload=$(cat "/sys/class/net/$1/statistics/tx_bytes")
    download=$(cat "/sys/class/net/$1/statistics/rx_bytes")

    echo "$upload $download"
    ;;
  Darwin)
    # column 7 is Ibytes (in bytes, rx, download) and column 10 is Obytes (out bytes, tx, upload)
    netstat -nbI "$1" | tail -n1 | awk '{print $10 " " $7}'
    ;;
  esac
}

# get_bandwidth return the number of bytes exchanged for tx and rx
get_bandwidth() {
  local upload=0
  local download=0

  IFS=' ' read -r upload download <<< "$(interface_bytes "$1")"

  # wait for interval to calculate the difference
  sleep "$INTERVAL"

  IFS=' ' read -r new_upload new_download <<< "$(interface_bytes "$1")"

  upload=$(( $new_upload - $upload ))
  download=$(( $new_download - $download ))

  # set to 0 by default
  echo "${upload:-0} ${download:-0}"
}

# bandwidth_to_unit convert bytes into its highest unit and add unit symbol in sec
bandwidth_to_unit() {
  local size=1
  for i in "${!SIZE[@]}"; do
    if (($1 < i)); then
      break
    fi

    size="$i"
  done

  local result="0.00"
  if (($1 != 0)); then
    result="$(awk -v a="$1" -v b="$size" 'BEGIN { printf "%.2f\n", a / b }' </dev/null)"
  fi

  echo "$result ${SIZE[$size]}"
}

main() {
  counter=0
  bandwidth=()

  network_name=""
  show_interface="$(tmux show-option -gqv "@kanagawa-network-bandwidth-show-interface")"
  interval_update="$(tmux show-option -gqv "@kanagawa-network-bandwidth-interval")"

  if [[ -z $interval_update ]]; then
    interval_update=0
  fi

  while true; do
    if ((counter == 0)); then
      counter=60
      network_name="$(interface_get)"
    fi

    IFS=" " read -ra bandwidth <<<"$(get_bandwidth "$network_name")"

    if [[ $show_interface == "true" ]]; then echo -n "[$network_name] "; fi
    echo "↓ $(bandwidth_to_unit "${bandwidth[$DOWNLOAD]}") • ↑ $(bandwidth_to_unit "${bandwidth[$UPLOAD]}")"

    ((counter = counter - 1))
    sleep "$interval_update"
  done
}

#run main driver
main
