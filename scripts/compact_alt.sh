#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

main()
{
  # get options
  min_width=$(get_tmux_option "@dracula-compact-min-width" "140")

  # narrow-mode is a global flag (@dracula-narrow-mode) baked into the single
  # shared status-right, so it must not depend on the calling client alone:
  # two attached clients with different widths would otherwise flip it back
  # and forth on every refresh (each flip rebuilding the bar). Decide from
  # ALL attached clients instead: compact whenever ANY of them is narrow.
  local narrowest_width
  narrowest_width=$(tmux list-clients -F '#{client_width}' | sort -n | head -1)
  if [[ -z "$narrowest_width" ]]; then
    narrowest_width=$(tmux display-message -p '#{client_width}')
  fi

  # determine whether narrow
  if [[ "$narrowest_width" -lt "$min_width" ]]; then
    narrow=true
  else
    narrow=false
  fi

  # get whether narrow previously
  narrow_mode="$(tmux show-option -gqv '@dracula-narrow-mode')"

  # if width changed, set global var and rebuild
  if [[ "$narrow" != "$narrow_mode" ]]; then
    # Serialize the flip: the status-right is assembled by resetting the
    # option and appending one segment per plugin, so two concurrent
    # rebuilds (e.g. one per attached client firing on the same tick)
    # interleave their appends and duplicate every segment. A mkdir lock is
    # atomic; stale locks from killed scripts expire after 1 minute.
    local lock_dir="${TMPDIR:-/tmp}/dracula-tmux-compact-alt.$UID"
    local acquired=false
    for _ in {1..50}; do
      if mkdir "$lock_dir" 2>/dev/null; then
        acquired=true
        break
      fi
      if [[ -n $(find "$lock_dir" -maxdepth 0 -mmin +1 2>/dev/null) ]]; then
        rm -rf "$lock_dir"
      fi
      sleep 0.1
    done
    if [[ "$acquired" == true ]]; then
      tmux set -g @dracula-narrow-mode "$narrow"
      # Re-source the config synchronously under the lock. This re-runs the
      # theme build AND every user setting that lives after the plugin load
      # in tmux.conf (status-style, window-status formats, ...), which a
      # bare theme rebuild would clobber with dracula defaults. tmux
      # serializes concurrent source-file commands at the option level, but
      # not their interleaved set-option calls, so the lock is still needed.
      tmux source-file "$(get_tmux_option "@dracula-config-path" "$HOME/.config/tmux/tmux.conf")"
      rmdir "$lock_dir" 2>/dev/null
    fi
    # if the lock never freed, skip: a rebuild is already in flight and
    # this decision is retried on the next refresh
  fi

  # show widget info if verbose
  verbose=$(get_tmux_option "@dracula-compact-alt-verbose" false)
  if $verbose; then
    echo "$narrowest_width - $narrow"
  fi
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  sleep $RATE
}

#run main driver program
main
