#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

linux_acpi() {
  arg=$1
  BAT=$(ls -d /sys/class/power_supply/*)
  if [ ! -x "$(which acpi 2> /dev/null)" ];then
    for DEV in $BAT; do
      case "$arg" in
        status)
          [ -f "$DEV/status" ] && cat "$DEV/status"
          ;;
        percent)
          [ -f "$DEV/capacity" ] && cat "$DEV/capacity"
          ;;
        *)
          ;;
      esac
    done
  else
    case "$arg" in
      status)
        acpi | cut -d: -f2- | cut -d, -f1 | tr -d ' '
        ;;
      percent)
        acpi | cut -d: -f2- | cut -d, -f2 | tr -d '% '
        ;;
      *)
        ;;
    esac
  fi
}

battery_percent()
{
  # Check OS
  case $(uname -s) in
    Linux)
      percent=$(linux_acpi percent)
      [ -n "$percent" ] && echo "$percent%"
      ;;

    Darwin)
      echo $(pmset -g batt | grep -Eo '[0-9]?[0-9]?[0-9]%')
      ;;

    FreeBSD)
      echo $(apm | sed '8,11d' | grep life | awk '{print $4}')
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # leaving empty - TODO - windows compatability
      ;;

    *)
      ;;
  esac
}

battery_status()
{
  # Check OS
  case $(uname -s) in
    Linux)
      status=$(linux_acpi status)
      ;;

    Darwin)
      status=$(pmset -g batt | sed -n 2p | cut -d ';' -f 2 | tr -d " ")
      ;;

    FreeBSD)
      status=$(apm | sed '8,11d' | grep Status | awk '{printf $3}')
      ;;

    CYGWIN*|MINGW32*|MSYS*|MINGW*)
      # leaving empty - TODO - windows compatability
      ;;

    *)
      ;;
  esac

  tmp_bat_perc=$(battery_percent)
  bat_perc="${tmp_bat_perc%\%}"

  case $status in
    discharging|Discharging)
      # discharging, no AC
      declare -A battery_labels=(
        [0]="󰂎"
        [10]="󰁺"
        [20]="󰁻"
        [30]="󰁼"
        [40]="󰁽"
        [50]="󰁾"
        [60]="󰁿"
        [70]="󰂀"
        [80]="󰂁"
        [90]="󰂂"
        [100]="󰁹"
      )
      echo "${battery_labels[$((bat_perc/10*10))]:-󰂃}"
      ;;
    high|charged|Full)
      echo "󰁹"
      ;;
    charging|Charging)
      # charging from AC
      declare -A battery_labels=(
        [0]="󰢟"
        [10]="󰢜"
        [20]="󰂆"
        [30]="󰂇"
        [40]="󰂈"
        [50]="󰢝"
        [60]="󰂉"
        [70]="󰢞"
        [80]="󰂊"
        [90]="󰂋"
        [100]="󰂅"
      )
      echo "${battery_labels[$((bat_perc/10*10))]:-󰂃}"
      ;;
    ACattached)
      # drawing from AC but not charging
      echo ''
      ;;
    finishingcharge)
      echo '󰂅'
      ;;
    *)
      # something wrong...
      echo ''
      ;;
  esac
  ### Old if statements didn't work on BSD, they're probably not POSIX compliant, not sure
  # if [ $status = 'discharging' ] || [ $status = 'Discharging' ]; then
  # 	echo ''
  # # elif [ $status = 'charging' ]; then # This is needed for FreeBSD AC checking support
  # 	# echo 'AC'
  # else
  #  	echo 'AC'
  # fi
}

main()
{
  bat_label=$(get_tmux_option "@dracula-battery-label" "♥")
  if [ "$bat_label" == false ]; then
    bat_label=""
  fi

  no_bat_label=$(get_tmux_option "@dracula-no-battery-label" "AC")
  if [ "$no_bat_label" == false ]; then
    no_bat_label=""
  fi

  show_bat_label=$(get_tmux_option "@dracula-show-battery-status" false)
  if $show_bat_label; then
    bat_stat=$(battery_status)
  else
    bat_stat=""
  fi

  bat_perc=$(battery_percent)

  if [ -z "$bat_stat" ]; then # Test if status is empty or not
    echo "$bat_label $bat_perc"
  elif [ -z "$bat_perc" ]; then # In case it is a desktop with no battery percent, only AC power
    echo "$no_bat_label"
  else
    echo "$bat_label$bat_stat $bat_perc"
  fi
}

#run main driver program
main
