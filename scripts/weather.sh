#!/usr/bin/env bash


fahrenheit=$1

load_request_params()
{
	city=$(curl -s https://ipinfo.io/city 2> /dev/null)
	region=$(curl -s https://ipinfo.io/region 2> /dev/null)
}


fetch_weather_information()
{
	display_weather=$1
	# it gets the weather condition textual name (%C), the temperature (%t), and the location (%l) 
	curl -sL curl wttr.in\?format="+%C+%t$display_weather"
}

#get weather display
display_weather()
{
	if $fahrenheit; then
		display_weather='&u' # for USA system
	else
		display_weather='&m' # for metric system
	fi
	weather_information=$(fetch_weather_information $display_weather)

	weather_condition=$(echo $weather_information | awk '{print $1;}') # Sunny, Snow, etc
	temperature=$(echo $weather_information | awk '{print $2;}') # +31°C, -3°F, etc
	unicode=$(forecast_unicode $weather_condition)

	echo "$unicode ${temperature/+/}" # remove the plus sign to the temperature
}

forecast_unicode() 
{
	weather_condition=$1

	if [[ $weather_condition =~ 'Snow' ]]; then
		echo '❄ '
	elif [[ (($weather_condition =~ 'Rain') || ($weather_condition =~ 'Shower')) ]]; then
		echo '☂ '
	elif [[ (($weather_condition =~ 'Overcast') || ($weather_condition =~ 'Cloud')) ]]; then
		echo '☁ '
	elif [[ $weather_condition = 'NA' ]]; then
		echo ''
	else
		echo '☀ '
	fi
}

main()
{
	load_request_params
	# process should be cancelled when session is killed
	if ping -q -c 1 -W 1 ipinfo.io &>/dev/null; then
		echo "$(display_weather) $city, $region"
	else
		echo "Location Unavailable"
	fi
}

#run main driver program
main
