#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$current_dir/utils.sh"

get_cpids_linux() {
  local ppid="$1"
  local cpids
  local cpid
  echo "$ppid"
  cpids="$(pgrep -P "$ppid")"
  for cpid in $cpids; do
    get_cpids_linux "$cpid"
  done
}

get_cpids_unix() {
  local ppid="$1"
  local cpids
  local cpid
  echo "$ppid"
  cpids="$(pgrep -aP "$ppid")"
  for cpid in $cpids; do
    get_cpids_unix "$cpid"
  done
}

kb_to_mb() {
  if [ $# == 0 ]; then
    read -r num
  else
    num="$1"
  fi
  bc <<< "scale=3;$num/1024"
}

kb_to_gb() {
  if [ $# == 0 ]; then
    read -r num
  else
    num="$1"
  fi
  bc <<< "scale=6;$num/1048576"
}

round() {
  if [ $# == 1 ]; then
    read -r num
    scale="$1"
  elif [ $# == 2 ]; then
    num="$1"
    scale="$2"
  fi
  printf "%.${scale}f" "${num}"
}

get_tmux_ram_usage()
{
  local pid
  local pids
  local total_mem_kb=0
  local total_mem_mb=0
  local total_mem_gb=0
  pid="$(tmux display-message -pF '#{pid}')"
  case $(uname -s) in
    Linux)
      if command -v pstree > /dev/null; then
        pids="$(pstree -p "$pid" | tr -d '\n' | sed -rn -e 's/[^()]*\(([0-9]+)\)[^()]*/\1,/g' -e 's/,$//p')"
      else
        pids="$(get_cpids_linux "$pid" | tr '\n' ',')"
      fi
      total_mem_kb="$(ps -o rss= -p "$pids" | paste -sd+ | bc)"
      ;;

    Darwin)
      if command -v pstree > /dev/null; then
        pids="$(pstree "$pid" | sed -En 's/[^0-9]+([0-9]+) .*/\1/p' | tr '\n' ',')"
      else
        pids="$(get_cpids_unix "$pid" | tr '\n' ',')"
      fi
      total_mem_kb="$(ps -o rss= -p "$pids" | paste -sd+ - | bc)"
      ;;

    FreeBSD)
      # TODO check FreeBSD compatibility
      if command -v pstree > /dev/null; then
        pids="$(pstree "$pid" | sed -En 's/[^0-9]+([0-9]+) .*/\1/p' | tr '\n' ',')"
      else
        pids="$(get_cpids_unix "$pid" | tr '\n' ',')"
      fi
      total_mem_kb="$(ps -o rss= -p "$pids" | paste -sd+ - | bc)"
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # TODO - windows compatability
      ;;
  esac
  total_mem_mb=$(kb_to_mb "$total_mem_kb" | round 0)
  total_mem_gb=$(kb_to_gb "$total_mem_kb" | round 0)

  if (( total_mem_gb > 0)); then
    echo "${total_mem_gb}GB"
  elif (( total_mem_mb > 0 )); then
    echo "${total_mem_mb}MB"
  else
    echo "${total_mem_kb}kB"
  fi
}

main()
{
  ram_label=$(get_tmux_option "@kanagawa-tmux-ram-usage-label" "MEM")
  ram_usage=$(get_tmux_ram_usage)
  echo "$ram_label $ram_usage"
}

#run main driver
main
