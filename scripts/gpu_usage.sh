#!/usr/bin/env bash

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

get_platform()
{
	case $(uname -s) in
		Linux)
			gpu=$(lspci -v | grep VGA | head -n 1 | awk '{print $5}')
			echo $gpu
		;;

		Darwin)
			# TODO - Darwin/Mac compatability
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# TODO - windows compatability
		;;
	esac
}
get_gpu()
{
	gpu=$(get_platform)
	if [[ "$gpu" == NVIDIA ]]; then
    usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | awk '{if ($1 < 10) {print "0"$1"%"} else {print $1"%"}}')
  else
    usage='unknown'
	fi
  echo $usage
}
main()
{
	# storing the refresh rate in the variable RATE, default is 5
	RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
	gpu_usage=$(get_gpu)
	echo "GPU $gpu_usage"
	sleep $RATE
}
# run the main driver
main
