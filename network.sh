#/usr/bin/env bash

#author: Dane Williams
#script for gathering internet connectivity info
#script is called in dracula.tmux program


get_ssid()
{
	if /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F: '/ SSID/{print $2}' &>/dev/null
		echo $(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F: '/ SSID/{print $2}')
	else
		echo 'Ethernet'
	fi
}

main()
{
	if ping -q -c 1 -W 1 google.com &>/dev/null; then
		echo "$(get_ssid)"
	else
		echo 'Offline'
	fi
}

#run main driver function
main
