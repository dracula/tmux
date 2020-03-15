#/usr/bin/env bash

#wrapper script for running weather on interval

main()
{
	while true
	do
		./weather.sh
		sleep 600
	done
}

#run main driver function
main
