#!/usr/bin/env bash


fahrenheit=$1

load_request_params()
{
	
	city=$(curl -s https://ipinfo.io/city 2> /dev/null)
	region=$(curl -s https://ipinfo.io/region 2> /dev/null)
	zip=$(curl -s https://ipinfo.io/postal 2> /dev/null | tail -1)
	country_w_code=$(curl -w "\n%{http_code}\n" -s https://ipinfo.io/country 2> /dev/null)
	country=`grep -Eo [a-zA-Z]+ <<< "$country_w_code"` 
	exit_code=`grep -Eo [0-9]{3} <<< "$country_w_code"`

	region_code_url=http://www.ip2country.net/ip2country/region_code.html
	weather_url=https://forecast.weather.gov/zipcity.php
}

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
	if $fahrenheit; then
		echo $(weather_information | grep 'deg;F' | cut -d '&' -f 1)
	else
		echo $(( ($(weather_information | grep 'deg;F' | cut -d '&' -f 1) - 32) * 5 / 9 ))
	fi
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
		echo "$(forecast_unicode)$(get_temp)° "
	else
		echo ''
	fi
}

main()
{
	# don't run the rest of the script unless we can safely get all the information
	load_request_params

	if [[ $exit_code -eq 429 ]]; then
		echo "Request Limit Reached"
		exit
	fi
	# process should be cancelled when session is killed
	if ping -q -c 1 -W 1 ipinfo.io &>/dev/null; then
		echo "$(display_weather)$city, $(get_region_code)"
	else
		echo "Location Unavailable"
	fi
}

#run main driver program
main
