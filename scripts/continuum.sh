#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

# configuration
# @dracula-continuum-mode default (default|alert|time)
# @dracula-continuum-time-threshold 15

alert_mode="@dracula-continuum-mode"
time_threshold="@dracula-continuum-time-threshold"
warn_threshold=15

last_auto_save_option="@continuum-save-last-timestamp"
auto_save_interval_option="@continuum-save-interval"
auto_save_interval_default="15"

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

current_timestamp() {
  echo "$(date +%s)"
}

time_since_last_run_passed() {
  local last_saved_timestamp="$(get_tmux_option "$last_auto_save_option" "0")"
  printf "%s" "$(($(current_timestamp) - last_saved_timestamp))"
}

print_status() {
  local mode="$(get_tmux_option "$alert_mode" "default")"
  local threshold="$(get_tmux_option "$time_threshold" "15")"
  local save_int="$(get_tmux_option "$auto_save_interval_option" "$auto_save_interval_default")"
  local interval_seconds="$((save_int * 60))"
  local status=""
  local time_delta="$(time_since_last_run_passed)"
  local time_delta_minutes="$((time_delta / 60))"

  case "$mode" in
    time)
      if [[ $save_int -gt 0 ]]; then
        if [[ "$time_delta" -gt $((interval_seconds+warn_threshold)) ]]; then
          status="no save after $time_delta_minutes minutes!"
        else
          status="$time_delta_minutes"
        fi
      else
        status="off"
      fi
      ;;

    alert)
      if [[ "$time_delta" -gt $((interval_seconds+warn_threshold)) ]]; then
        status="no save after $time_delta_minutes minutes!"
      elif [[ "$time_delta" -le "$threshold" ]]; then
        status="saved"
      elif [[ $save_int -gt 0 ]]; then
        status=""
      else
        status="off"
      fi
      ;;

    *)
      if [[ "$time_delta" -le "$threshold" ]]; then
        status="saved"
      elif [[ $save_int -gt 0 ]]; then
        status="$save_int"
      else
        status="off"
      fi
      ;;
  esac
  echo "$status"
}
print_status
