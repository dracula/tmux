#!/usr/bin/env bash

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
			gpu=$(lspci -v | grep -i gpu | grep driver | awk '{print $5}')
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
	if [ $gpu == nvidia-gpu ]; then
		usage=$(nvidia-smi | grep "%" | awk '{print $13}')
		echo $usage
	fi
}
main()
{
	RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
	gpu_usage=$(get_gpu)
	echo "GPU $gpu_usage"
	sleep $RATE
}
# run the main driver
main


