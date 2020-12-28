#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

# function for getting the refresh rate
get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z $option_value ]; then
    echo $default_value
  else
    echo $option_value
  fi
}

get_percent()
{
	case $(uname -s) in
		Linux)
			percent=$(LC_NUMERIC=en_US.UTF-8 top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
			echo $percent
		;;
		
		Darwin)
			cpuvalue=$(ps -A -o %cpu | awk -F. '{s+=$1} END {print s}')
			cpucores=$(sysctl -n hw.logicalcpu)
			cpuusage=$(( cpuvalue / cpucores ))
			percent="$cpuusage%"
			echo $percent
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# TODO - windows compatability
		;;
	esac
}

main()
{
	# storing the refresh rate in the variable RATE, default is 5
	RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
	cpu_percent=$(get_percent)
	echo "CPU $cpu_percent"
	sleep $RATE
}

# run main driver
main
