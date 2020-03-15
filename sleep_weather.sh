#/usr/bin/env bash

#wrapper script for running weather on interval

main()
{
	while tmux has-session &> /dev/null
	do
		./weather.sh > ~/.tmux/plugins/tmux-dracula/weather.txt
		if [ (cat ~/.tmux/plugins/tmux-dracula/weather.txt | sed -n 2p) =~ '  "error": {' ]; then
			echo "Too Many Requests" > ~/.tmux/plugins/tmux-dracula/weather.txt
			break
		fi
		sleep 1000
	done
}

#run main driver function
main
