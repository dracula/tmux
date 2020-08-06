#!/usr/bin/env bash

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
    usage=$(nvidia-smi | grep '%' | awk '{ sum += $13 } END { printf("%d%%\n", sum / NR) }')
  else
    usage='unknown'
	fi
  echo $usage
}
main()
{
	gpu_usage=$(get_gpu)
	echo "GPU $gpu_usage"
	sleep 10
}
# run the main driver
main
