#/usr/bin/env bash

#wrapper script for running weather on interval

main()
{
	while true
	do
		./weather.sh > ~/.tmux/plugins/tmux-dracula/weather.txt
		if tmux has-session &> /dev/null
		then
			sleep 1000
		else
			break
		fi
	done
}

#run main driver function
main
