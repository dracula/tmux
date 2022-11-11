#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

# configuration
# @dracula-continuum-mode default (countdown|time|alert|interval)
# @dracula-continuum-time-threshold 15

alert_mode="@dracula-continuum-mode"
time_threshold="@dracula-continuum-time-threshold"
warn_threshold=360
first_save="@dracula-continuum-first-save"

# tmux-resurrect and tmux-continuum options
if [ -d "$HOME/.tmux/resurrect" ]; then
  default_resurrect_dir="$HOME/.tmux/resurrect"
else
  default_resurrect_dir="${XDG_DATA_HOME:-$HOME/.local/share}"/tmux/resurrect
fi
resurrect_dir_option="@resurrect-dir"
last_auto_save_option="@continuum-save-last-timestamp"
auto_save_interval_option="@continuum-save-interval"
auto_save_interval_default="15"

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

current_timestamp() {
  echo "$(date +%s)"
}

file_mtime() {
  if [ ! -f "$1" ]; then
    echo -1
    return
  fi
  case $(uname -s) in
    Linux|Darwin)
      date -r "$1" +%s
      ;;

    FreeBSD)
      stat -f %m "$1"
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # TODO - windows compatability
      ;;
  esac
}

timestamp_date() {
  case $(uname -s) in
    Linux)
      date -d "@$1" "$2"
      ;;

    Darwin|FreeBSD)
      date -r "$1" "$2"
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # TODO - windows compatability
      ;;
  esac
}

set_tmux_option() {
  local option="$1"
  local value="$2"
  tmux set-option -gq "$option" "$value"
}

# tmux-resurrect dir
resurrect_dir() {
  if [ -z "$_RESURRECT_DIR" ]; then
    local path="$(get_tmux_option "$resurrect_dir_option" "$default_resurrect_dir")"
    # expands tilde, $HOME and $HOSTNAME if used in @resurrect-dir
    echo "$path" | sed "s,\$HOME,$HOME,g; s,\$HOSTNAME,$(hostname),g; s,\~,$HOME,g"
  else
    echo "$_RESURRECT_DIR"
  fi
}
_RESURRECT_DIR="$(resurrect_dir)"

last_resurrect_file() {
  echo "$(resurrect_dir)/last"
}

last_saved_timestamp() {
  local last_saved_timestamp="$(get_tmux_option "$last_auto_save_option" "")"
  local first_save_timestamp="$(get_tmux_option "$first_save" "")"
  # continuum sets the last save timestamp to the current time on first load if auto_save_option is not set
  # so we can outrace it and detect that last_uato_save_option is empty and the timestamp is a dummy save
  if [ -z "$first_save_timestamp" ]; then
    last_saved_timestamp="$(file_mtime "$(last_resurrect_file)")" || last_saved_timestamp=-1
    set_tmux_option "$first_save" "$last_saved_timestamp"
  elif [ "$first_save_timestamp" != "done" ]; then
    last_saved_timestamp="$(file_mtime "$(last_resurrect_file)")" || last_saved_timestamp=-1
    if [ "$last_saved_timestamp" -gt "$first_save_timestamp" ]; then
      set_tmux_option "$first_save" "done"
    else
      last_saved_timestamp="$first_save_timestamp"
    fi
  fi
  echo "$last_saved_timestamp"
}

print_status() {
  local mode="$(get_tmux_option "$alert_mode" "countdown")"
  local info_threshold="$(get_tmux_option "$time_threshold" "15")"
  local save_int="$(get_tmux_option "$auto_save_interval_option" "$auto_save_interval_default")"
  local interval_seconds="$((save_int * 60))"
  local status=""
  local last_timestamp="$(last_saved_timestamp)"
  local time_delta="$(($(current_timestamp) - last_timestamp))"
  local time_delta_minutes="$((time_delta / 60))"

  if [[ $save_int -gt 0 ]]; then
    if [[ "$time_delta" -gt $((interval_seconds + warn_threshold)) ]]; then
      if [[ "$last_timestamp" == -1 ]]; then
        status="no save"
      else
        status="last save: $(timestamp_date "$last_timestamp" '+%F %T')"
      fi
      if [[ "$mode" == "countdown" ]]; then
        # continuum timestamp may be different than file timestamp on first load
        local last_continuum_timestamp="$(get_tmux_option "$last_auto_save_option" "")"
        time_delta="$(($(current_timestamp) - last_continuum_timestamp))"
        time_delta_minutes="$((time_delta / 60))"

        status="$status; T$(printf '%+d' "$((time_delta_minutes - save_int))")min"
      fi
    elif [[ "$time_delta" -le "$info_threshold" ]]; then
      status="saved"
    else
      case "$mode" in
        countdown)
          status="T$(printf '%+d' "$((time_delta_minutes - save_int))")min";
          ;;

        time)
          status="$time_delta_minutes";
          ;;

        alert)
          status=""
          ;;

        interval)
          status="$save_int"
          ;;
      esac
    fi
  else
    status="off"
  fi

  echo "$status"
}
print_status
