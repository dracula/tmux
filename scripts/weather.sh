#!/usr/bin/env bash


fahrenheit=$1

weather_information()
{
	display_weather=$1
	# it gets the weather condition (%c), the temperature (%t), and the location (%l) 
	curl -sL curl wttr.in\?format="+%c+%t+%l$display_weather"
}

#get weather display
display_weather()
{
	if $fahrenheit; then
		display_weather='&u' # for USA system
	else
		display_weather='&m' # for metric system
	fi
	echo $(weather_information $display_weather)
}

main()
{
	# process should be cancelled when session is killed
	if ping -q -c 1 -W 1 ipinfo.io &>/dev/null; then
		echo "$(display_weather)"
	else
		echo "Location Unavailable"
	fi
}

#run main driver program
main
