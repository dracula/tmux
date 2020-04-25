#/usr/bin/env bash

#wrapper script for running weather on interval

temp_unit=$1
echo "2 called weather.sh with $temp_unit" > /tmp/sleepweatherout

main()
{
	current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

	$current_dir/weather.sh $temp_unit > $current_dir/../data/weather.txt
	
	while tmux has-session &> /dev/null
	do
		$current_dir/weather.sh $temp_unit > $current_dir/../data/weather.txt
		if tmux has-session &> /dev/null
		then
			sleep 1200
		else
			break
		fi
	done
}

#run main driver function
main
