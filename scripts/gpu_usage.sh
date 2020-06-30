#!/usr/bin/env bash

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
	gpu_usage=$(get_gpu)
	echo "GPU $gpu_usage"
	sleep 10
}
# run the main driver
main


