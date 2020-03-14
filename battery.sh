#!/usr/bin/env bash

battery_percent()
{
	echo $(pmset -g batt | grep -Eo '[0-9]?[0-9]?[0-9]%')
}

battery_status()
{
	status=$(pmset -g batt | sed -n 2p | cut -d ';' -f 2)

	if [ $status = 'discharging' ]; then
		echo ''
	else
		echo 'Charging '
	fi
}

main()
{
	bat_stat=$(battery_status)
	bat_perc=$(battery_percent)
	echo "♥ $bat_stat$bat_perc"
}

main

