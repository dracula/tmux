"󰈀 "
"󰣀 "
"󱍢 "
"󰉉 "



## left icon

The left icon can be set to anything static you'd like.
However if you use tmux on multiple machines, it may be helpful to display the hostname.
If you use multiple sessions simultaneously it can be good to name them and have the name in the left icon.
the following example uses formatting to display "hostname | session_name":
`set -g @dracula-show-left-icon "#h | #S"`

formats:
`#H: Hostname of local host`
`#h: Hostname of local host (no domain name)`
`#S: name of session` -> alias trs to tmux rename-session
more formats can be found here, though those without a shorthand like #H need to be used like #{host}, which is equivalent.
[tmux(1) - OpenBSD manual pages](https://man.openbsd.org/tmux.1#FORMATS)

besides formats, any other string can be used.

## continuum

@dracula-continuum-mode
@dracula-continuum-time-threshold
@dracula-continuum-first-save
@resurrect-dir
@continuum-save-last-timestamp
@continuum-save-interval

## cpu_info
Displays cpu usage in percent by default, but can display cpu load on linux, if the following flag is set to true:
`set -g @dracula-cpu-display-load false`
Additionally the label can be set to whatever you'd like.
`set -g @dracula-cpu-usage-label "CPU"`
If you're using nerdfonts, try one of the following.
`   󰍛 󰘚 󰻟 󰻠 `

`set -g @dracula-refresh-rate` affects this widget
## gpu_info
"󰢮 "

  RATE=$(get_tmux_option "@dracula-refresh-rate" 5)
  ignore_lspci=$(get_tmux_option "@dracula-ignore-lspci" false)
  gpu_label=$(get_tmux_option "@dracula-gpu-usage-label" "GPU")
  gpu_label=$(get_tmux_option "@dracula-gpu-usage-label" "VRAM")
  gpu_label=$(get_tmux_option "@dracula-gpu-usage-label" "GPU")

## network
**This will only display the wifi you're connected to, if it provides internet access!**
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
