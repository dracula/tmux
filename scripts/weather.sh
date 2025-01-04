#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=C.utf8

fahrenheit=$1
location=$2
fixedlocation=$3

# emulate timeout command from bash - timeout is not available by default on OSX
if [ "$(uname)" == "Darwin" ]; then
  timeout() {
      perl -e 'alarm shift; exec @ARGV' "$duration" "$@"
  }
fi

display_location()
{
  if $location && [[ ! -z "$fixedlocation" ]]; then
    echo " $fixedlocation"
  elif $location; then
    city=$(curl -s https://ipinfo.io/city 2> /dev/null)
    region=$(curl -s https://ipinfo.io/region 2> /dev/null)
    echo " $city, $region"
  else
    echo ''
  fi
}

fetch_weather_information()
{
  display_weather=$1
  # it gets the weather condition textual name (%C), and the temperature (%t)
  api_response=$(curl -sL wttr.in/${fixedlocation// /%20}\?format="%C+%t$display_weather")

  if [[ $api_response = "Unknown location;"* ]]; then
    echo "Unknown location error"
  else
    echo $api_response
  fi
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

  weather_condition=$(echo "$weather_information" | awk -F' -?[0-9]' '{print $1}' | xargs) # Extract condition before temperature, e.g. Sunny, Snow, etc
  temperature=$(echo "$weather_information" | grep -oE '[-+]?[0-9]+°[CF]') # Extract temperature, e.g. +31°C, -3°F, etc
  unicode=$(forecast_unicode $weather_condition)

  # Mac Only variant should be transparent on Linux
  if [[ "${temperature/+/}" == *"===="* ]]; then
    temperature="error"
  fi

  if [[ "${temperature/+/}" == "error" ]]; then
    # Propagate Error
    echo "error"
  else
    echo "$unicode ${temperature/+/}" # remove the plus sign to the temperature
  fi
}

forecast_unicode()
{
  weather_condition=$(echo $weather_condition | awk '{print tolower($0)}')

  if [[ $weather_condition =~ 'snow' ]]; then
    echo '❄ '
  elif [[ (($weather_condition =~ 'rain') || ($weather_condition =~ 'shower')) ]]; then
    echo '☂ '
  elif [[ (($weather_condition =~ 'overcast') || ($weather_condition =~ 'cloud')) ]]; then
    echo '☁ '
  elif [[ $weather_condition = 'NA' ]]; then
    echo ''
  else
    echo '☀ '
  fi
}

main()
{
  # process should be cancelled when session is killed
  if timeout 1 bash -c "</dev/tcp/ipinfo.io/443" && timeout 1 bash -c "</dev/tcp/wttr.in/443" && [[ "$(display_weather)" != "error" ]]; then
    echo "$(display_weather)$(display_location)"
  else
    echo "Weather Unavailable"
  fi
}

#run main driver program
main
