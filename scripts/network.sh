#/usr/bin/env bash

#author: Dane Williams
#script for gathering internet connectivity info
#script is called in dracula.tmux program


get_ssid()
{
	# Check OS
	case $(uname -s) in
		Linux)
			if iw dev | grep ssid | cut -d ' ' -f 2 &> /dev/null; then
				echo $(iw dev | grep ssid | cut -d ' ' -f 2)
			else
				echo ' Ethernet'
			fi
		;;

		Darwin)
			if /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep -E ' SSID' | cut -d ':' -f 2 &> /dev/null; then
				echo "$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | grep -E ' SSID' | cut -d ':' -f 2)"
			else
				echo ' Ethernet'
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
	if ping -q -c 1 -W 1 github.com &>/dev/null; then
		echo "$(get_ssid)"
	else
		echo ' Offline'
	fi
}

#run main driver function
main
