#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $current_dir/utils.sh

vpn_function() {
  case $(uname -s) in
  Linux)
    # TODO
  ;;
  
  Darwin)
    vpn=$(scutil --nc list | grep Connected)

    if [ -z $vpn ]; then
      echo ""
    else
      echo "VPN"
    fi
    ;;

  CYGWIN* | MINGW32* | MSYS* | MINGW*)
    # TODO - windows compatability
    ;;
  esac
}

main() {

  echo $(vpn_function)
}

# run main driver
main
