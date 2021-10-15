#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

INTERVAL=$(get_tmux_option "@dracula-refresh-rate" 5)

default_network_name=$(ip route | grep default | sed -e "s/^.*dev.//" -e "s/.proto.*//")
network_name=$(get_tmux_option "@dracula-network-bandwith" "$default_network_name")

main() {
    output_download=""
    output_upload=""
    output_download_unit=""
    output_upload_unit=""

    initial_download=$(cat /sys/class/net/$network_name/statistics/rx_bytes)
    initial_upload=$(cat /sys/class/net/$network_name/statistics/tx_bytes)

    sleep $INTERVAL

    final_download=$(cat /sys/class/net/$network_name/statistics/rx_bytes)
    final_upload=$(cat /sys/class/net/$network_name/statistics/tx_bytes)

    total_download_bps=$(echo "$final_download $initial_download $INTERVAL" | awk '{printf "%.0f \n", ($1 - $2) / $3}')
    total_upload_bps=$(echo "$final_upload $initial_upload $INTERVAL" | awk '{printf "%.0f \n", ($1 - $2) / $3}')

    if [ $total_download_bps -gt 1073741824 ]; then
      output_download=$(echo "$total_download_bps 1024" | awk '{printf "%.2f \n", $1/($2 * $2 * $2)}')
      output_download_unit="gB/s"
    elif [ $total_download_bps -gt 1048576 ]; then
      output_download=$(echo "$total_download_bps 1024" | awk '{printf "%.2f \n", $1/($2 * $2)}')
      output_download_unit="mB/s"
    else
      output_download=$(echo "$total_download_bps 1024" | awk '{printf "%.2f \n", $1/$2}')
      output_download_unit="kB/s"
    fi

    if [ $total_upload_bps -gt 1073741824 ]; then
      output_upload=$(echo "$total_download_bps 1024" | awk '{printf "%.2f \n", $1/($2 * $2 * $2)}')
      output_upload_unit="gB/s"
    elif [ $total_upload_bps -gt 1048576 ]; then
      output_upload=$(echo "$total_upload_bps 1024" | awk '{printf "%.2f \n", $1/($2 * $2)}')
      output_upload_unit="mB/s"
    else
      output_upload=$(echo "$total_upload_bps 1024" | awk '{printf "%.2f \n", $1/$2}')
      output_upload_unit="kB/s"
    fi

    echo "↓ $output_download $output_download_unit • ↑ $output_upload $output_upload_unit"
}
main
