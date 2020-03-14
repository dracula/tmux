#!/usr/bin/env bash

main() {

  ## Colors
  white='#f8f8f2'  #'colour255'
  gray='#44475a' #'colour236'
  dark_gray='#282a36' #'colour236'
  yellow='#f1fa8c' #'colour215'
  light_purple='#bd93f9' #'colour141'
  dark_purple='#6272a4' #'colour61'
  cyan='#8be9fd'
  green='#50fa7b'
  orange='#ffb86c'
  pink='#ff79c6'
  red='#ff555'

  ## Icons
  left_sep=''
  right_sep=''
  right_alt_sep=''

  tmux set-option -g pane-border-style "fg=${dark_purple}"
  tmux set-option -g pane-active-border-style "fg=${pink}"
  tmux set-option -g status on
  tmux set-option -g status-left-length 100
  tmux set-option -g status-right-length 100
  tmux set-option -g status-bg "${dark_gray}"
  tmux set-option -g pane-active-border-fg "${dark_purple}"
  tmux set-option -g pane-border-fg "${gray}"
  tmux set-option -g message-bg "${gray}"
  tmux set-option -g message-fg "${white}"
  tmux set-option -g message-command-bg "${gray}"
  tmux set-option -g message-command-fg "${white}"
  tmux set-option -g status-left " #I #[fg=${dark_gray},reverse]${right_sep} "
  tmux set-option -g status-left-style "fg=${white},bg=${dark_purple},bold"
  tmux set-option -g status-right "${left_sep}#[bg=${black},reverse] %Y-%m-%d %H:%M "
  tmux set-option -g status-right-style "fg=${light_purple},bg=${dark_gray}"
  tmux set-window-option -g window-status-activity-style "fg=${white},bg=${gray}"
  tmux set-window-option -g window-status-separator ''
  tmux set-window-option -g window-status-format ' #I #W '
  tmux set-window-option -g window-status-style "fg=${yellow},bg=${dark_gray}"
  tmux set-window-option -g window-status-current-format \
    "${right_sep}#[fg=${black}] #I ${right_alt_sep} #W #[fg=${dark_gray},reverse]${right_sep}"
  tmux set-window-option -g window-status-current-style "fg=${dark_gray},bg=${light_purple}"
}

main

# vim: set filetype=bash
