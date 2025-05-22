#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

get_percent()
{
  case $(uname -s) in
    Linux)
      percent=$(LC_NUMERIC=en_US.UTF-8 top -bn2 -d 0.01 | grep "[C]pu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
      normalize_percent_len $percent
      ;;

    Darwin)
      cpuvalue=$(ps -A -o %cpu | awk -F. '{s+=$1} END {print s}')
      cpucores=$(sysctl -n hw.logicalcpu)
      cpuusage=$(( cpuvalue / cpucores ))
      percent="$cpuusage%"
      normalize_percent_len $percent
      ;;

    OpenBSD)
      cpuvalue=$(ps -A -o %cpu | awk -F. '{s+=$1} END {print s}')
      cpucores=$(sysctl -n hw.ncpuonline)
      cpuusage=$(( cpuvalue / cpucores ))
      percent="$cpuusage%"
      normalize_percent_len $percent
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # TODO - windows compatability
      ;;
  esac
}

get_load() {
  case $(uname -s) in
  Linux | Darwin | OpenBSD)
    loadavg=$(uptime | awk -F'[a-z]:' '{ print $2}' | sed 's/,//g')
    echo $loadavg
    ;;

  CYGWIN* | MINGW32* | MSYS* | MINGW*)
    # TODO - windows compatability
    ;;
  esac
}

main() {
  # storing the refresh rate in the variable RATE, default is 5
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  cpu_load=$(get_tmux_option "@dracula-cpu-display-load" false)
  cpu_label=$(get_tmux_option "@dracula-cpu-usage-label" "CPU")
  if [ "$cpu_load" = true ]; then
    echo "$cpu_label $(get_load)"
  else
    cpu_percent=$(get_percent)
    echo "$cpu_label $cpu_percent"
  fi
  sleep $RATE
}

# run main driver
main
