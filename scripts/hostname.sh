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

get_platform()
{
	case $(uname -s) in
		Linux|Darwin)
			hostname=$(hostname -f)
			echo $hostname
		;;

		CYGWIN*|MINGW32*|MSYS*|MINGW*)
			# TODO - windows compatability
		;;
	esac
}
get_hostname()
{
	hostname=$(get_platform)
  echo $hostname
}
main()
{
	# storing the refresh rate in the variable RATE, default is 5
	RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
	hostname=$(get_hostname)
	echo "@ $hostname"
	sleep $RATE
}
# run the main driver
main
