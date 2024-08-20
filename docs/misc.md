## left icon

pretty example:
`set -g @dracula-show-left-icon "#h | #S"`

formats:
`#H: Hostname of local host`
`#h: Hostname of local host (no domain name)`
`#S: name of session` -> alias trs to tmux rename-session
more formats can be found here, though those without a shorthand like #H need to be used like #{host}, which is equivalent.
[tmux(1) - OpenBSD manual pages](https://man.openbsd.org/tmux.1#FORMATS)

besides formats, any other string can be used.
## continuum

alert_mode="@dracula-continuum-mode"
time_threshold="@dracula-continuum-time-threshold"
warn_threshold=360
first_save="@dracula-continuum-first-save"

## cpu_info

  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  cpu_load=$(get_tmux_option "@dracula-cpu-display-load" false)
  cpu_label=$(get_tmux_option "@dracula-cpu-usage-label" "CPU")

## gpu_info

  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  ignore_lspci=$(get_tmux_option "@dracula-ignore-lspci" false)
  gpu_label=$(get_tmux_option "@dracula-gpu-usage-label" "GPU")
  gpu_label=$(get_tmux_option "@dracula-gpu-usage-label" "VRAM")
  gpu_label=$(get_tmux_option "@dracula-gpu-usage-label" "GPU")

## network
**this will only display the wifi youre connected to, if it provides internet access!**
## network bandwidth
tmux show-option -gqv "@dracula-network-bandwidth"
## network ping
    pingserver=$(get_tmux_option "@dracula-ping-server" "google.com")
  RATE=$(get_tmux_option "@dracula-ping-rate" 5)
## playerctl

  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  FORMAT=$(get_tmux_option "@dracula-playerctl-format" "Now playing: {{ artist }} - {{ album }} - {{ title }}")
## ram usage
  ram_label=$(get_tmux_option "@dracula-ram-usage-label" "RAM")
## spotify tui
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  FORMAT=$(get_tmux_option "@dracula-spotify-tui-format" "%f %s %t - %a")
  max_len=$(get_tmux_option "@dracula-spotify-tui-max-len" 0)
## synchronise panes
  current_synchronize_panes_status=$(get_tmux_window_option "synchronize-panes" "off")
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
## terraform
  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
## tmux ram usage
  ram_label=$(get_tmux_option "@dracula-tmux-ram-usage-label" "MEM")
