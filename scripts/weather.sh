#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=C.utf8

API_URL="https://wttr.in"
DELIM=":"

# emulate timeout command from bash - timeout is not available by default on OSX
if [ "$(uname)" == "Darwin" ]; then
  function timeout() {
    local _duration
    _duration="${1:-1}"
    command -p perl -e 'alarm shift; exec @ARGV' "$_duration" "$@"
  }
fi

# Fetch weather information from remote API
# Globals:
#   DELIM
# Arguments:
#   show fahrenheit, either "true" or "false"
#   optional fixed location to query weather data about
function fetch_weather_information() {
  local _show_fahrenheit _location _unit
  _show_fahrenheit="$1"
  _location="$2"

  if "$_show_fahrenheit"; then
    _unit="u"
  else
    _unit="m"
  fi

  command -p curl -sL "${API_URL}/${_location// /%20}?format=%C${DELIM}%t${DELIM}%l&${_unit}"
}

# Format raw weather information from API
# Globals:
#   DELIM
# Arguments:
#   The raw weather data as returned by "fetch_weather_information()"
#   show location, either "true" or "false"
function format_weather_info() {
  local _raw _show_location
  _raw="$1"
  _show_location="$2"

  local _weather _temp _location
  _weather="${_raw%%"${DELIM}"*}"  # slice temp and location to get weather
  _temp="${_raw#*"${DELIM}"}"      # slice weather to get temp and location
  _temp="${_temp%%"${DELIM}"*}"    # slice location to get temp
  _temp="${_temp/+/}"              # slice "+" from "+74°F"
  _location="${_raw##*"${DELIM}"}" # slice weather and temp to get location
  [ "${_location//[^,]/}" == ",," ] &&
    _location="${_location%,*}" # slice country if it exists

  case "${_weather,,}" in
  'snow')
    _weather='❄'
    ;;
  'rain' | 'shower')
    _weather='☂'
    ;;
  'overcast' | 'cloud')
    _weather='☁'
    ;;
  'na')
    _weather=''
    ;;
  *)
    _weather='☀'
    ;;
  esac

  if "$_show_location"; then
    printf '%s %s %s' "$_weather" "$_temp" "$_location"
  else
    printf '%s %s' "$_weather" "$_temp"
  fi
}

# Display weather, temperature, and location
# Globals
#   none
# Arguments
#   show fahrenheit, either "true" (default) or "false"
#   show location, either "true" (default) or "false"
#   optional fixed location to query data about, e.g. "Houston, Texas"
function main() {
  local _show_fahrenheit _show_location _location
  _show_fahrenheit="${1:-true}"
  _show_location="${2:-true}"
  _location="$3"

  # process should be cancelled when session is killed
  if ! timeout 1 bash -c "</dev/tcp/ipinfo.io/443"; then
    printf "Weather Unavailable\n"
    return
  fi

  local _resp
  _resp=$(fetch_weather_information "$_show_fahrenheit" "$_location")

  if [[ "$_resp" = "Unknown location"* ]]; then
    printf 'Unknown location error\n'
    return
  fi

  format_weather_info "$_resp" "$_show_location"
}

main "$@"
