#!/usr/bin/env bash

#author: Dane Williams
#script for gathering current location and weather at location
#script is then called in the dracula.tmux program

# test if rate limit hit
exit=$(curl --write-out "%{http_code}\n" --silent --output /dev/null ipinfo.io)

if [ $exit -eq 429 ] ; then
	echo "Response Rate Limit Reached"
	return
	

city=$(curl -s https://ipinfo.io/city 2> /dev/null)
region=$(curl -s https://ipinfo.io/region 2> /dev/null)
zip=$(curl -s https://ipinfo.io/postal 2> /dev/null | tail -1)
country=$(curl -s https://ipinfo.io/country 2> /dev/null)

region_code_url=http://www.ip2country.net/ip2country/region_code.html
weather_url=https://forecast.weather.gov/zipcity.php

#substitute region code for regions in north america
get_region_code()
{
	curl -s $region_code_url | grep $region &> /dev/null && region=$(curl -s $region_code_url | grep $region | cut -d ',' -f 2)
	echo $region
}

weather_information()
{
	curl -sL $weather_url?inputstring=$zip | grep myforecast-current | grep -Eo '>.*<' | sed -E 's/>(.*)</\1/'
}
get_temp()
{
	weather_information | grep 'deg;F' | cut -d '&' -f 1
}
forecast_unicode() 
{
	forecast=$(weather_information | head -n 1)

	if [[ $forecast =~ 'Snow' ]]; then
		echo '❄ '
	elif [[ (($forecast =~ 'Rain') || ($forecast =~ 'Shower')) ]]; then
		echo '☂ '
	elif [[ (($forecast =~ 'Overcast') || ($forecast =~ 'Cloud')) ]]; then
		echo '☁ '
	elif [[ $forecast = 'NA' ]]; then
		echo ''
	else
		echo '☀ '
	fi
	

}
#get weather display if in US
display_weather()
{
	if [ $country = 'US' ]; then
		echo "$(forecast_unicode)$(get_temp)°F"
	else
		echo ''
	fi
}

main()
{
	# process should be cancelled when session is killed
	if ping -q -c 1 -W 1 ipinfo.io &>/dev/null; then
		echo "$(display_weather) $city, $(get_region_code)"
	else
		echo "Location Unavailable"
	fi
}

#run main driver program
main
