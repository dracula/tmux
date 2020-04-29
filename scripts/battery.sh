#!/usr/bin/env bash

battery_percent()
{
	# Check OS
	case $(uname -s) in
		Linux)
			cat /sys/class/power_supply/BAT0/capacity
		;;

		Darwin)
			echo $(pmset -g batt | grep -Eo '[0-9]?[0-9]?[0-9]%')
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# leaving empty - TODO - windows compatability
		;;

		*)
		;;
	esac
}

battery_status()
{
	# Check OS
	case $(uname -s) in
		Linux)
			status=$(cat /sys/class/power_supply/BAT0/status)
		;;

		Darwin)
			status=$(pmset -g batt | sed -n 2p | cut -d ';' -f 2)
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# leaving empty - TODO - windows compatability
		;;

		*)
		;;
	esac

	if [ $status = 'discharging' ] || [ $status = 'Discharging' ]; then
		echo ''
	else
	 	echo 'AC '
	fi
}

main()
{
	bat_stat=$(battery_status)
	bat_perc=$(battery_percent)
	echo "♥ $bat_stat$bat_perc"
}

#run main driver program
main

