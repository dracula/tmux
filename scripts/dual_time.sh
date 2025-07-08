#!/usr/bin/env bash

military=$(tmux show-option -gqv "@dracula-time-military" | tr '[:upper:]' '[:lower:]')

time_fmt="%I:%M %p"

if [[ "$military" == "true" || "$military" == "1" ]]; then
  time_fmt="%H:%M"
fi

timezones=$(tmux show-option -gqv "@dracula-time")
[ -z "$timezones" ] && timezones="UTC"

IFS=',' read -ra TZ_ARRAY <<<"$timezones"

output=()
for tz in "${TZ_ARRAY[@]}"; do
  tz=$(echo "$tz" | xargs) # Trim whitespace
  label=$(basename "$tz" | tr '_' ' ')
  if [ -f "/usr/share/zoneinfo/$tz" ]; then
    time=$(env TZ="$tz" /bin/date +"${label} ${time_fmt}")
    output+=("$time")
  else
    output+=("${label} N/A")
  fi
done

joined=""
for i in "${!output[@]}"; do
  if [ "$i" -gt 0 ]; then
    joined+=" | "
  fi
  joined+="${output[$i]}"
done
echo "$joined"
