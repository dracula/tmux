#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

DATAFILE="/tmp/.dracula-tmux-weather-data"
LAST_EXEC_FILE="/tmp/.dracula-tmux-weather-last-exec"
INTERVAL=1200

# Call weather script on interval to prevent exhausting remote API
# Globals:
#   DATAFILE
#   LAST_EXEC_FILE
#   INTERVAL
# Arguments:
#   show fahrenheit, either "true" (default) or "false"
#   show location, either "true" (default) or "false"
#   optional fixed location to query data about, e.g. "Houston, Texas"
function main() {
  local _show_fahrenheit _show_location _location _current_dir _last _now
  _show_fahrenheit="$1"
  _show_location="$2"
  _location="$3"
  _current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  _last=$(cat "$LAST_EXEC_FILE" 2>/dev/null || echo 0)
  _now=$(date +%s)

  if (((_now - _last) > INTERVAL)); then
    # Run weather script here
    "${_current_dir}/weather.sh" "$_show_fahrenheit" "$_show_location" "$_location" >"${DATAFILE}"
    printf '%s' "$_now" >"${LAST_EXEC_FILE}"
  fi

  cat "${DATAFILE}"
}

main "$@"
