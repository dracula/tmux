#!/usr/bin/env bash

# a tmux color scheme inspired by dracula
# author: Dane Williams

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

main()
{
  # set current directory variable
  current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  show_battery=$(get_tmux_option "@dracula-show-battery" true)
  show_network=$(get_tmux_option "@dracula-show-network" true)
  show_weather=$(get_tmux_option "@dracula-show-weather" true)
  temperature_unit=$(get_tmux_option "@dracula-temperature-unit" "F")

  # Dracula Color Pallette
  white='#f8f8f2'
  gray='#44475a'
  dark_gray='#282a36'
  light_purple='#bd93f9'
  dark_purple='#6272a4'
  cyan='#8be9fd'
  green='#50fa7b'
  orange='#ffb86c'
  red='#ff5555'
  pink='#ff79c6'
  yellow='#f1fa8c'

  # start weather script in background
  if $show_weather; then
    env TEMPUNIT="$temperature_unit" $current_dir/sleep_weather.sh &
  fi

  # set refresh interval
  tmux set-option -g status-interval 5

  # set clock
  tmux set-option -g clock-mode-style 12

  # set length 
  tmux set-option -g status-left-length 100
  tmux set-option -g status-right-length 100

  # pane border styling
  tmux set-option -g pane-active-border-style "fg=${dark_purple}"
  tmux set-option -g pane-border-style "fg=${gray}"

  # message styling
  tmux set-option -g message-style "bg=${gray},fg=${white}"

  # status bar
  tmux set-option -g status-style "bg=${gray},fg=${white}"

  tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} ☺ " 

  tmux set-option -g  status-right ""

  if $show_battery; then
    tmux set-option -g  status-right "#[fg=${dark_gray},bg=${pink}] #($current_dir/battery.sh) "
  fi

  if $show_network; then
    tmux set-option -ga status-right "#[fg=${dark_gray},bg=${cyan}]#($current_dir/network.sh) "
  fi

  if $show_weather; then
    tmux set-option -ga status-right "#[fg=${dark_gray},bg=${orange}] #(cat $current_dir/../data/weather.txt) " 
  fi

  tmux set-option -ga status-right "#[fg=${white},bg=${dark_purple}] %a %m/%d %I:%M %p #(date +%Z) "
  
  # window tabs 
  tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I #W "
  tmux set-window-option -g window-status-format "#[fg=${white}]#[bg=${gray}] #I #W "
}

# run main function
main
