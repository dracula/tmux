#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

INTERVAL=$(get_tmux_option "@dracula-refresh-rate" 5)

default_network_name=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")
network_name=$(get_tmux_option "@dracula-network-bandwith" "$default_network_name")

main() {
    initial_download=$(cat /sys/class/net/$network_name/statistics/rx_bytes)
    initial_upload=$(cat /sys/class/net/$network_name/statistics/tx_bytes)

    sleep $INTERVAL

    final_download=$(cat /sys/class/net/$network_name/statistics/rx_bytes)
    final_upload=$(cat /sys/class/net/$network_name/statistics/tx_bytes)

    total_download_bps=$(expr $final_download - $initial_download)
    total_upload_bps=$(expr $final_upload - $initial_upload)

    total_download_kbps=$(echo "$total_download_bps 1024 $INTERVAL" | awk '{printf "%.2f \n", $1/$2/$3}')
    total_upload_kbps=$(echo "$total_upload_bps 1024 $INTERVAL" | awk '{printf "%.2f \n", $1/$2/$3}')

    echo "↓ $total_download_kbps kB/s • ↑ $total_upload_kbps kB/s"
}

main
