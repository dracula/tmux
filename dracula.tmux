#!/usr/bin/env bash

# a tmux color scheme inspired by dracula
# author: Dane Williams


main()
{

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

  # set refresh interval
  tmux set-option -g status-interval 1

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

  # run scripts in background
  ./sleep_weather.sh > ~/.tmux/plugins/tmux-dracula/weather.txt &
  #./internet.sh > internet.txt &

  # status bar
  tmux set-option -g status-style "bg=${gray},fg=${white}"

  tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} ☺ " 

  tmux set-option -g  status-right "#[fg=${dark_gray},bg=${pink}] #(~/.tmux/plugins/tmux-dracula/battery.sh) "
  tmux set-option -ga status-right "#[fg=${dark_gray},bg=${cyan}] tructus "
  tmux set-option -ga status-right "#[fg=${dark_gray},bg=${orange}] #(cat ~/.tmux/plugins/tmux-dracula/weather.txt) " 
  tmux set-option -ga status-right "#[fg=${white},bg=${dark_purple}] %a %m/%d %I:%M %p #(date +%Z) "
  
  # window tabs 
  tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I #W "
  tmux set-window-option -g window-status-format "#[fg=${white}]#[bg=${gray}] #I #W "

}

# run main function
main

