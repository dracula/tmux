#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

main()
{
  # get options
  min_width=$(get_tmux_option "@dracula-compact-min-width" "200")

  # get current window with
  local window_width
  window_width=$(tmux display-message -p "#{window_width}")

  # determine whether narrow
  if [[ "$window_width" -lt "$min_width" ]]; then
    narrow=true
  else
    narrow=false
  fi

  # get whether narrow previously
  narrow_mode="$(tmux show-option -gqv '@dracula-narrow-mode')"

  # if width changed, set global var and reload
  if [[ "$narrow" != "$narrow_mode" ]]; then
    tmux set -g @dracula-narrow-mode $narrow
    tmux source-file ~/.config/tmux/tmux.conf
  fi
  echo "$window_width aa $narrow"
}

#run main driver program
main
