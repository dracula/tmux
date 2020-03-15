#/usr/bin/env bash

#wrapper script for running weather on interval

main()
{
	while true
	do
		./weather.sh > ~/.tmux/plugins/tmux-dracula/weather.txt
		sleep 600
	done
}

#run main driver function
main
