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
			used_mem=$(top -l 1 -s 0 | grep PhysMem | sed 's/[a-z]//g; s/[A-Z]//g; s/[()]//g' | awk '{printf "%d\n", $2-$3-$5}')
			total_mem=$(system_profiler SPHardwareDataType | grep "Memory:" | awk '{print $2 $3}')
			if (( $used_mem < 1024 )); then
				echo $used_mem\M\B/$total_mem
			else
				memory=$(($used_mem/1024))
				echo $memory\G\B/$total_mem
			fi
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
