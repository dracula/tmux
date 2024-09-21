# misc --- sort me **TODO**
  IFS=' ' read -r -a plugins <<< $(get_tmux_option "@dracula-plugins" "battery network weather")
set -g @dracula-show-empty-plugins true

set -g @dracula-show-flags false
set -g @dracula-border-contrast false
set -g @dracula-refresh-rate 5
set -g @dracula-time-format ""
set -g @dracula-show-ssh-session-port false
set -g @dracula-show-libreview false
# powerline
set -g @dracula-show-powerline false
set -g @dracula-show-left-sep 
set -g @dracula-show-right-sep 
# left icon
- The left icon can be set to anything static you'd like.
- However if you use tmux on multiple machines, it may be helpful to display the hostname.
- If you use multiple sessions simultaneously it can be good to name them and have the name in the left icon.

the following example uses formatting to display "hostname | session_name":
```
set -g @dracula-show-left-icon "#h | #S"
```
formats:
```
#H: Hostname of local host
#h: Hostname of local host (no domain name)
#S: name of session -> suggestion: alias trs to tmux rename-session
```
more formats can be found here, though those without a shorthand like #H need to be used like #{host}, which is equivalent.
[reference: tmux(1) - OpenBSD manual pages](https://man.openbsd.org/tmux.1#FORMATS)

besides formats, any other string can be used.

additionally the left icons padding can be set like so:
```
set -g @dracula-left-icon-padding 1
```
# right widgets
## attached clients
this widget provides the number of clients attached to the current tmux session.

set the number of clients attached, required to show any output. if less clients are attached, the widget shows no output.
```
set -g @dracula-clients-minimum 1
```
set the labels used for singular and plural clients.
```
set -g @dracula-clients-plural "clients"
set -g @dracula-clients-singular "client"
```

`set -g @dracula-refresh-rate 5` affects this widget
## battery
this widget provides information about the current charge of the battery, whether it is attached to a powersupply and charging from it, or running off the powersupply without charging. it also detects desktop pcs having no battery.

Display any icon for the battery you'd like with:
```
set -g @dracula-battery-label "♥ "
```

to use nothing but nerdfont icons informing you about the current state, use the following,
which will display the battery charge and whether its charging (or just drawing from AC) as nerdfont icons.
```
set -g @dracula-battery-label false
set -g @dracula-show-battery-status true
```
if you have no battery and would like the widget to hide in that case, set the following:
```
set -g @dracula-no-battery-label false
```
alternatively, if you have no battery and would like a nerdfont icon to indicate that, consider setting the following:
```
set -g @dracula-no-battery-label " "
```
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
```
󰉉
```
## cpu info
this widget displays the cpu usage in percent by default, but can display cpu load on linux:
```
set -g @dracula-cpu-display-load true
```

possible nerdfont settings for cpu usage label:
```
set -g @dracula-cpu-usage-label " "
```

nerdfont icons to consider:
```
   󰍛 󰘚 󰻟 󰻠
```

`set -g @dracula-refresh-rate 5` affects this widget
## current working directory
this widget displays the path of the current working directory
## fossil
**TODO**
## git
this widget displays info about the current git repository.

**TODO**
```
set -g @dracula-git-disable-status "false"
set -g @dracula-git-show-current-symbol "✓"
set -g @dracula-git-show-diff-symbol "!"
set -g @dracula-git-no-repo-message ""
set -g @dracula-git-no-untracked-files "false"
set -g @dracula-git-show-remote-status "false"
```
## gpu info
these widgets display the current computational, ram, and power usage of installed graphics cards.

hardware support:
- full support for NVIDIA gpus.
- partial support for apple m-chips.

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

possible nerdfont settings for gpu info labels:
```
set -g @dracula-gpu-power-label "󰢮 "
set -g @dracula-gpu-usage-label "󰢮 "
set -g @dracula-gpu-vram-label "󰢮 "
```

TODO:
- add support for amd without testing and clarify that this is an experimental feature! ask someone whos got an amd card to test it.

nerdfont icons to consider:
```
󰢮
```

`set -g @dracula-refresh-rate 5` affects this widget
## mercurial
this widget displays info about the current mercurial repository.

**TODO**
```
set -g @dracula-hg-disable-status "false"
set -g @dracula-hg-show-current-symbol "✓"
set -g @dracula-hg-show-diff-symbol "!"
set -g @dracula-hg-no-repo-message ""
set -g @dracula-hg-no-untracked-files "false"
```
## kubernetes context
set -g @dracula-kubernetes-context-label ""
set -g @dracula-kubernetes-eks-hide-arn false
set -g @dracula-kubernetes-eks-extract-account false
set -g @dracula-kubernetes-hide-user false

hide_arn_from_cluster=$1
extract_account=$2
hide_user=$3
just_current_context=$4
label=$5
## libre
This script retrieves and displays continuous glucose monitoring (CGM) data from the LibreView API.
It caches the data to minimize API requests and displays the latest glucose level along with a trend indicator in a Tmux status bar.
## mpc
this widget displays music information provided by mpc.

to format the display format:
```
set -g @dracula-mpc-format "%title% - %artist%"
```

`set -g @dracula-refresh-rate 5` affects this widget
## network
this widget displays one of three states: offline, ethernet connected, or wifi connected.
however, per default **this will only display the wifi you're connected to, if it provides internet access!**

you can use different hosts to ping in order to check for a wifi or wired connection.
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
this widget gives the currently used up and download speeds per second for one interface.

to set a specific network interface you'd like to monitor, used:
```
set -g @dracula-network-bandwidth "eno0"
```
to display the interface name alongside the speeds, set:
```
set -g @dracula-network-bandwidth-show-interface true
```
per default, this widget checks the speeds as frequently as it can. to set longer intervals, use the following:
```
set -g @dracula-network-bandwidth-interval 5
```
## network ping
this widget displays the current ping to a specific server.

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
this widget displays music information provided by playerctl.

to change the display format set:
```
set -g @dracula-playerctl-format "Now playing: {{ artist }} - {{ album }} - {{ title }}"
```

`set -g @dracula-refresh-rate 5` affects this widget
## ram usage
this widget displays the currently used ram as GB per GB.

possible nerdfont settings for ram usage:
```
set -g @dracula-ram-usage-label " "
```

nerdfont icons to consider:
```
   󰍛 󰘚
```
## spotify tui
this widget displays music information provided by spotify-tui. spotify-tui must be installed to use this widget.

to format the display format:
```
set -g @dracula-spotify-tui-format "%f %s %t - %a"
```

to limit the maximum length (0 means unlimited length):
```
set -g @dracula-spotify-tui-max-len 30
```

`set -g @dracula-refresh-rate 5` affects this widget
## ssh session
this widget displays the current username@host combination, both of the local machine as well as when connected via ssh.

to output nothing (and maybe hide the widget) when not connected via ssh:
```
set -g @dracula-show-ssh-only-when-connected true
```

nerdfont icons to consider:
```
󰣀
```
## synchronise panes
this widget displays whether the tmux panes are currently synchronised or not.

to change the label:
```
set -g @dracula-synchronize-panes-label "Sync"
```

`set -g @dracula-refresh-rate 5` affects this widget
## terraform
**TODO**

```
set -g @dracula-terraform-label ""
```

`set -g @dracula-refresh-rate 5` affects this widget
## time
**TODO**
```
set -g @dracula-military-time false
set -g @dracula-set-timezone ""
set -g @dracula-show-timezone true
set -g @dracula-day-month false
```
## tmux ram usage
this widget displays the ram currently used by tmux.

possible nerdfont settings for tmux ram usage:
```
@dracula-tmux-ram-usage-label " "
```

nerdfont icons to consider:
```
   󰍛 󰘚
```
## weather
**TODO**

```
set -g @dracula-show-fahrenheit true
set -g @dracula-show-location true
set -g @dracula-fixed-location
```

      script="#($current_dir/weather_wrapper.sh $show_fahrenheit $show_location '$fixed_location')"
## custom scripts
**TODO**

```
  for plugin in "${plugins[@]}"; do

    if case $plugin in custom:*) true;; *) false;; esac; then
      script=${plugin#"custom:"}
      if [[ -x "${current_dir}/${script}" ]]; then
        IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-custom-plugin-colors" "cyan dark_gray")
        script="#($current_dir/${script})"
      else
        colors[0]="red"
        colors[1]="dark_gray"
        script="${script} not found!"
      fi
```
