
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

**TODO**

```
@dracula-continuum-mode
@dracula-continuum-time-threshold
@dracula-continuum-first-save
@resurrect-dir
@continuum-save-last-timestamp
@continuum-save-interval
```

nerdfont icons to consider:
`󰉉 `

## cpu_info

Displays cpu usage in percent by default, but can display cpu load on linux:
`set -g @dracula-cpu-display-load true`

Additionally the label can be set to whatever you'd like.
`set -g @dracula-cpu-usage-label "CPU"`

nerdfont icons to consider:
`   󰍛 󰘚 󰻟 󰻠 `

`set -g @dracula-refresh-rate 5` affects this widget

## gpu_info

full support for NVIDIA gpus.
partial support for apple m-chips

if your gpu is not recognised, force the script to assume a certain brands.
```
set -g @dracula-force-gpu "NVIDIA"
```

to display the used vram in percent (gigabyte is default unit):
```
set -g @dracula-gpu-vram-percent true
```

vram usage is displayed in gigabyte without decimal places per default. to change that behaviour, use the following options with the respective number of decimal places you'd like to get:
```
set -g @dracula-gpu-vram-used-accuracy ".2f"
set -g @dracula-gpu-vram-total-accuracy ".1f"
```

to display the power usage in percent (watt is default unit):
```
set -g @dracula-gpu-power-percent true
```

default gpu info labels:
```
set -g @dracula-gpu-usage-label "GPU"
set -g @dracula-gpu-vram-label "VRAM"
set -g @dracula-gpu-power-label "GPU"
```

possible nerdfont settings for gpu info labels:
```
set -g @dracula-gpu-power-label "󰢮 "
set -g @dracula-gpu-usage-label "󰢮 "
set -g @dracula-gpu-vram-label "󰢮 "
```

TODO:
- add support for amd without testing and clarify that this is an experimental feature! ask someone whos got an amd card to test it.

nerdfont icons to consider:
`󰢮  `

`set -g @dracula-refresh-rate 5` affects this widget

## network

**This will only display the wifi you're connected to, if it provides internet access!**

use different hosts to ping in order to check for a wifi or wired connection.
if you frequently use networks without internet access, you can use local ip-addresses here to still display the connection.
```
set -g @dracula-network-hosts "1.1.1.1 8.8.8.8"
```

possible nerdfont settings for network info:
```
set -g @dracula-network-ethernet-label "󰈀 Eth"
set -g @dracula-network-offline-label "󱍢 "
set -g @dracula-network-wifi-label " "
```

nerdfont icons to consider:
```
ethernet: 󰈀 󰒪 󰒍 󰌗 󰌘
offline: 󰖪  󱍢
wifi:      󰖩  󰘊 󰒢
```

known issues:
- if for some reason `iw` is only in the path for root and not the normal user, wifi connections will be considered ethernet connections.

## network bandwidth

**TODO**

tmux show-option -gqv "@dracula-network-bandwidth"

## network ping

to use a custom server:
```
set -g @dracula-ping-server "1.1.1.1"
```

to set the rate at which to ping the server (in seconds):
```
set -g @dracula-ping-rate 5
```
## network vpn

**TODO**

set -g @dracula-network-vpn-verbose true

TODO:
set -g @dracula-network-vpn-label

## playerctl

to change the display format:
```
set -g @dracula-playerctl-format "Now playing: {{ artist }} - {{ album }} - {{ title }}"
```

`set -g @dracula-refresh-rate 5` affects this widget
## ram usage

possible nerdfont settings for ram usage:
```
set -g @dracula-ram-usage-label " "
```

nerdfont icons to consider:
`   󰍛 󰘚 `

## ssh session

to output nothing (and maybe hide) the widget when not connected via ssh:
```
set -g @dracula-show-ssh-only-when-connected true
```

nerdfont icons to consider:
`󰣀 `

## spotify tui

to format the display format:
```
set -g @dracula-spotify-tui-format "%f %s %t - %a"
```

to limit the maximum length (0 means unlimited length):
```
set -g @dracula-spotify-tui-max-len 30
```

`set -g @dracula-refresh-rate 5` affects this widget

## synchronise panes

**TODO**

```
current_synchronize_panes_status=$(get_tmux_window_option "synchronize-panes" "off")
```

`set -g @dracula-refresh-rate 5` affects this widget
## terraform

`set -g @dracula-refresh-rate 5` affects this widget
## tmux ram usage

possible nerdfont settings for tmux ram usage:
```
@dracula-tmux-ram-usage-label " "
```

nerdfont icons to consider:
`   󰍛 󰘚 `
