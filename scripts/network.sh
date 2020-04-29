#!/usr/bin/env bash

HOSTS="google.com github.com example.com"

get_ssid()
{
	# Check OS
	case $(uname -s) in
		Linux)
			if iw dev | grep ssid | cut -d ' ' -f 2 &> /dev/null; then
				echo "$(iw dev | grep ssid | cut -d ' ' -f 2)"
			else
				echo 'Ethernet'
			fi
		;;

		Darwin)
			if /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep -E ' SSID' | cut -d ':' -f 2 &> /dev/null; then
				echo "$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep -E ' SSID' | cut -d ':' -f 2)"
			else
				echo 'Ethernet'
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
	network="Offline"
	for host in $HOSTS; do
	    if ping -q -c 1 -W 1 $host &>/dev/null; then
		    network="$(get_ssid)"
		    break
	    fi
	done

	echo " $network"
}

#run main driver function
main
