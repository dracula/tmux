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

network_name=$(tmux show-option -gqv "@dracula-network-bandwidth")

# interface_bytes give interface name and signal tx/rx return Bytes
interface_bytes() {
  cat "/sys/class/net/$1/statistics/$2_bytes"
}

# get_bandwidth return the number of bytes exchanged for tx and rx
get_bandwidth() {
  upload="$(interface_bytes "$network_name" "tx")"
  download="$(interface_bytes "$network_name" "rx")"

  #wait the interval for Wait for interval to calculate the difference
  sleep "$INTERVAL"

  upload="$(bc <<<"$(interface_bytes "$network_name" "tx") - $upload")"
  download="$(bc <<<"$(interface_bytes "$network_name" "rx") - $download")"

  #set to 0 by default useful for non-existent interface
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
    result="$(bc <<<"scale=2; $1 / $size")"
  fi

  echo "$result ${SIZE[$size]}"
}

main() {
  bandwidth=()

  while true; do
    IFS=" " read -ra bandwidth <<<"$(get_bandwidth)"
    echo "↓ $(bandwidth_to_unit "${bandwidth[$DOWNLOAD]}") • ↑ $(bandwidth_to_unit "${bandwidth[$UPLOAD]}")"
  done
}

#run main driver
main
