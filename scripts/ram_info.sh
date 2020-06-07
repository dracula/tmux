#!/usr/bin/env bash

get_percent()
{
	case $(uname -s) in
		Linux)
			# percent=$(free -m | awk 'NR==2{printf "%.1f%%\n", $3*100/$2}')
			used_mem=$(free -g | grep Mem: | awk '{mem += $3} END {print mem}')
			total_mem=$(free -h | grep Mem: | awk '{mem += $2} END {print mem}')
			if (( $used_mem == 0 )); then
				memory_usage=$(free -m | grep Mem: | awk '{mem += $3} END {print mem}')
				echo $memory_usage\M\B/$total_mem\G\B
			else
				memory_usage=$(free -g | grep Mem: | awk '{mem += $3} END {print mem}')
				echo $memory_usage\G\B/$total_mem\G\B
			fi
		;;

		Darwin)
			# percent=$(ps -A -o %mem | awk '{mem += $1} END {print mem}')
			used_mem=$(top -l 1 -s 0 | grep PhysMem | awk '{mem += $2} END {print mem}')
			total_mem=$(system_profiler SPHardwareDataType | grep "Memory:" | awk '{print $2 $3}' | sed 's/used//g')
			echo $used_mem/$total_mem\G\B
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# TODO - windows compatability
		;;
	esac
}

main()
{
	ram_percent=$(get_percent)
	echo "RAM $ram_percent"
	sleep 10
}

#run main driver
main
