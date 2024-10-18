#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

get_ratio()
{
  case $(uname -s) in
    Linux)
      usage="$(free -h | awk 'NR==2 {print $3}')"
      total="$(free -h | awk 'NR==2 {print $2}')"
      formated="${usage}/${total}"
      
      echo "${formated//i/B}"
      ;;

    Darwin)
      # Get used memory blocks with vm_stat, multiply by page size to get size in bytes, then convert to MiB
      used_mem=$(vm_stat | grep ' active\|wired\|compressor\|speculative' | sed 's/[^0-9]//g' | paste -sd ' ' - | awk -v pagesize=$(pagesize) '{printf "%d\n", ($1+$2+$3+$5) * pagesize / 1048576}')
      # System Profiler performs an activation lock check, which can result in
      # time outs or a lagged response. (~10 seconds)
      # total_mem=$(system_profiler SPHardwareDataType | grep "Memory:" | awk '{print $2 $3}')
      total_mem=$(sysctl -n hw.memsize | awk '{print $0/1024/1024/1024 " GB"}')
      if ((used_mem < 1024 )); then
        echo "${used_mem}MB/$total_mem"
      else
        memory=$((used_mem/1024))
        echo "${memory}GB/$total_mem"
      fi
      ;;

    FreeBSD)
      # Looked at the code from neofetch
      hw_pagesize="$(sysctl -n hw.pagesize)"
      mem_inactive="$(($(sysctl -n vm.stats.vm.v_inactive_count) * hw_pagesize))"
      mem_unused="$(($(sysctl -n vm.stats.vm.v_free_count) * hw_pagesize))"
      mem_cache="$(($(sysctl -n vm.stats.vm.v_cache_count) * hw_pagesize))"

      free_mem=$(((mem_inactive + mem_unused + mem_cache) / 1024 / 1024))
      total_mem=$(($(sysctl -n hw.physmem) / 1024 / 1024))
      used_mem=$((total_mem - free_mem))
      echo $used_mem
      if ((used_mem < 1024 )); then
        echo "${used_mem}MB/$total_mem"
      else
        memory=$((used_mem/1024))
        echo "${memory}GB/$total_mem"
      fi
      ;;

    OpenBSD)
      # vmstat -s | grep "pages managed" | sed -ne 's/^ *\([0-9]*\).*$/\1/p'
      # Looked at the code from neofetch
      hw_pagesize="$(pagesize)"
      used_mem=$(( ( 
$(vmstat -s | grep "pages active$" | sed -ne 's/^ *\([0-9]*\).*$/\1/p') +
$(vmstat -s | grep "pages inactive$" | sed -ne 's/^ *\([0-9]*\).*$/\1/p') +
$(vmstat -s | grep "pages wired$" | sed -ne 's/^ *\([0-9]*\).*$/\1/p') +
$(vmstat -s | grep "pages zeroed$" | sed -ne 's/^ *\([0-9]*\).*$/\1/p') +
0) * hw_pagesize / 1024 / 1024 ))
      total_mem=$(($(sysctl -n hw.physmem) / 1024 / 1024))
      #used_mem=$((total_mem - free_mem))
      total_mem=$(($total_mem/1024))
      if (( $used_mem < 1024 )); then
        echo $used_mem\M\B/$total_mem\G\B
      else
        memory=$(($used_mem/1024))
        echo $memory\G\B/$total_mem\G\B
      fi
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # TODO - windows compatability
      ;;
  esac
}

main()
{
  ram_label=$(get_tmux_option "@dracula-ram-usage-label" "RAM")
  ram_ratio=$(get_ratio)
  echo "$ram_label $ram_ratio"
}

#run main driver
main
