#!/usr/bin/env bash

INTERVAL="1"  # update interval in seconds

network_name=$(tmux show-option -gqv "@dracula-network-bandwidth")

main() {
  while true
  do
    initial_download=$(cat /sys/class/net/$network_name/statistics/rx_bytes)
    initial_upload=$(cat /sys/class/net/$network_name/statistics/tx_bytes)

    sleep $INTERVAL

    final_download=$(cat /sys/class/net/$network_name/statistics/rx_bytes)
    final_upload=$(cat /sys/class/net/$network_name/statistics/tx_bytes)

    total_download_bps=$(expr $final_download - $initial_download)
    total_upload_bps=$(expr $final_upload - $initial_upload)

    total_download_kbps=$(echo "$total_download_bps 1024" | awk '{printf "%.2f \n", $1/$2}')
    total_upload_kbps=$(echo "$total_upload_bps 1024" | awk '{printf "%.2f \n", $1/$2}')

    echo "↓ $total_download_kbps kB/s • ↑ $total_upload_kbps kB/s"
  done
}
main
