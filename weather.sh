#!/usr/bin/env bash

#author: Dane Williams
#script for gathering current location and weather at location
#script is then called in the dracula.tmux program

city=$(curl -s https://ipinfo.io/city 2> /dev/null)


main()
{
	echo $IP
}

#run main driver program
main
