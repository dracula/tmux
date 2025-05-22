#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

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
#   API_URL
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

  # If the user provies a "fixed location", `@dracula-fixed-location`, that the
  # API does not recognize, the API may suggest a users actual geoip GPS
  # location in the response body. This can lead to user PI leak.
  # Drop response body when status code >= 400 and return nonzero by passing the
  # `--fail` flag. Execute curl last to allow the consumer to leverage the
  # return code. Pass `--show-error` and redirect stderr for the consumer.
  command -p curl -L --silent --fail --show-error \
    "${API_URL}/${_location// /%20}?format=%C${DELIM}%t${DELIM}%l&${_unit}" 2>&1
}

# Format raw weather information from API
# Globals:
#   DELIM
# Arguments:
#   The raw weather data as returned by "fetch_weather_information()"
#   show location, either "true" or "false"
function format_weather_info() {
  local _raw _show_location
  _raw="$1" # e.g. "Rain:+63°F:Houston, Texas, United States"
  _show_location="$2"

  local _weather _temp _location
  _weather="${_raw%%"${DELIM}"*}"                                  # slice temp and location to get weather
  _weather=$(printf '%s' "$_weather" | tr '[:upper:]' '[:lower:]') # lowercase weather, OSX’s bash3.2 does not support ${v,,}
  _temp="${_raw#*"${DELIM}"}"                                      # slice weather to get temp and location
  _temp="${_temp%%"${DELIM}"*}"                                    # slice location to get temp
  _temp="${_temp/+/}"                                              # slice "+" from "+74°F"
  _location="${_raw##*"${DELIM}"}"                                 # slice weather and temp to get location
  [ "${_location//[^,]/}" == ",," ] && _location="${_location%,*}" # slice country if it exists

  case "$_weather" in
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
  if ! timeout 1 bash -c "</dev/tcp/wttr.in/443"; then
    printf 'Weather Unavailable\n'
    return
  fi

  # BashFAQ/002: assignment of substitution does not effect status code.
  local _resp
  if ! _resp=$(fetch_weather_information "$_show_fahrenheit" "$_location"); then

    # e.g. "curl: (22) The requested URL returned error: 404"
    case "${_resp##* }" in
    404)
      printf 'Unknown Location\n'
      ;;
    *)
      printf 'Weather Unavailable\n'
      ;;
    esac

    return
  fi

  format_weather_info "$_resp" "$_show_location"
}

main "$@"
