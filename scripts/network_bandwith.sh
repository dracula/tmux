#!/usr/bin/env bash

INTERVAL="1"  # update interval in seconds

network_name=$(tmux show-option -gqv "@dracula-network-bandwith")

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

    total_download_kbps=$(echo "scale=2; $total_download_bps / 1024" | bc)
    total_upload_kbps=$(echo "scale=2; $total_upload_bps / 1024" | bc)

    echo "↓ $total_download_kbps kB/s • ↑ $total_upload_kbps kB/s"
  done
}
main
