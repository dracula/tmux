## [tmux](https://github.com/tmux/tmux/wiki)

### Table of Contents
- [Configuration](#Configuration-up---up)
- [Status bar options](#status-bar-options---up)
- [Color theming](/docs/color_theming/README.md)
- Plugins
  - [attached-clients](#attached-clients---up)
  - [battery](#battery---up)
  - [continuum](#continuum---up)
  - [cpu-usage](#cpu-info---up)
  - [cwd](#current-working-directory---up)
  - [fossil](#fossil---up)
  - [git](#git---up)
  - [GPU Info (gpu-usage, gpu-ram-usage, gpu-power-draw)](#gpu-info---up)
  - [hg](#mercurial---up)
  - [Kerberos TGT (krbtgt)](#Kerberos-TGT---up)
  - [kubernetes-context](#kubernetes-context---up)
  - [libreview](#libre---up)
  - [mpc](#mpc---up)
  - [network](#network---up)
  - [network-bandwidth](#network-bandwidth---up)
  - [network-ping](#network-ping---up)
  - [network-vpn](#network-vpn---up)
  - [playerctl](#playerctl---up)
  - [ram-usage](#ram-usage---up)
  - [rpi-temp](#rpi-temp---up)
  - [spotify-tui](#spotify-tui---up)
  - [ssh-session](#ssh-session---up)
  - [synchronize-panes](#synchronize-panes---up)
  - [terraform](#terraform---up)
  - [time](#time---up)
  - [tmux-ram-usage](#tmux-ram-usage---up)
  - [weather](#weather---up)
  - [custom:](#custom-scripts---up)

### Configuration - [up](#table-of-contents)

The following configuration works regardless of whether you are using `$HOME/.tmux.conf`, or `$XDG_CONFIG_HOME/tmux/tmux.conf`.
To enable plugins set up the `@dracula-plugins` option in your `.tmux.conf` file, separate plugin by space.
The order that you define the plugins will be the order on the status bar left to right.

```bash
# available plugins: battery, cpu-usage, git, gpu-usage, ram-usage, tmux-ram-usage, network, network-bandwidth, network-ping, ssh-session, attached-clients, network-vpn, weather, time, mpc, spotify-tui, krbtgt, playerctl, kubernetes-context, synchronize-panes
set -g @dracula-plugins "cpu-usage gpu-usage ram-usage"
```

For each plugin is possible to customize background and foreground colors

```bash
# available colors: white, gray, dark_gray, light_purple, dark_purple, cyan, green, orange, red, pink, yellow
# set -g @dracula-[plugin-name]-colors "[background] [foreground]"
set -g @dracula-cpu-usage-colors "pink dark_gray"
```

### Status bar options - [up](#table-of-contents)

Enable powerline symbols

```bash
set -g @dracula-show-powerline true
```

Switch powerline symbols

```bash
# for left
set -g @dracula-show-left-sep 

# for right symbol (can set any symbol you like as separator)
set -g @dracula-show-right-sep 
```

Enable window flags

```bash
set -g @dracula-show-flags true
```

Adjust the refresh rate for the status bar

```bash
# the default is 5, it can accept any number
set -g @dracula-refresh-rate 5
```

Switch the left smiley icon

```bash
# it can accept `hostname` (full hostname), `session`, `shortname` (short name), `smiley`, `window`, or any character.
set -g @dracula-show-left-icon session
```

Add padding to the left smiley icon

```bash
# default is 1, it can accept any number and 0 disables padding.
set -g @dracula-left-icon-padding 1
```

Enable high contrast pane border

```bash
set -g @dracula-border-contrast true
```

Hide empty plugins

```bash
set -g @dracula-show-empty-plugins false
```

Make the powerline background transparent

```bash
set -g @dracula-powerline-bg-transparent true

# the left separator symbol is inversed with a transparent background, you can modify it with any symbol you like
set -g @dracula-inverse-divider 
```

### [color theming](/docs/color_theming/README.md) - [up](#table-of-contents)

Each individual widget's foreground and background color can be overridden.
Additionally, the variables used for storing color values can be overridden and extended.
This allows for the use of custom themes like catppuccin or gruvbox.

For everything regarding colors, please refer to [the color theming directory](/docs/color_theming/README.md).

### Plugins
#### attached-clients options - [up](#table-of-contents)
This widget provides the number of clients attached to the current tmux session.

Set the minimum number of clients to show (otherwise, show nothing)

```bash
set -g @dracula-clients-minimum 1
```

Set the label when there is one client, or more than one client

```bash
set -g @dracula-clients-singular client
set -g @dracula-clients-plural clients
```

#### battery options - [up](#table-of-contents)
This widget provides information about the current charge of the battery, whether it is attached to a powersupply and charging from it, or running off the powersupply without charging. it also detects desktop pcs having no battery.

Display any icon for the battery you'd like with:
```bash
set -g @dracula-battery-label "♥ "
```

to use nothing but nerdfont icons informing you about the current state, use the following,
which will display the battery charge and whether its charging (or just drawing from AC) as nerdfont icons.

```bash
set -g @dracula-battery-label false
set -g @dracula-show-battery-status true
```

if you have no battery and would like the widget to hide in that case, set the following:

```bash
set -g @dracula-no-battery-label false
```

alternatively, if you have no battery and would like a nerdfont icon to indicate that, consider setting the following:

```bash
set -g @dracula-no-battery-label " "
```

#### continuum options - [up](#table-of-contents)

Set the output mode. Options are:
- **countdown**: Show a T- countdown to the next save (default)
- **time**: Show the time since the last save
- **alert**: Hide output if no save has been performed recently
- **interval**: Show the continuum save interval

```bash
set -g @dracula-continuum-mode countdown
```

Show if the last save was performed less than 60 seconds ago (default threshold is 15 seconds)

```bash
set -g @dracula-continuum-time-threshold 60
```

Other options.
```bash
@dracula-continuum-first-save
@resurrect-dir
@continuum-save-last-timestamp
@continuum-save-interval
```

#### cpu-usage options - [up](#table-of-contents)
This widget displays the cpu usage in percent by default, but can display cpu load on linux.
Load average – is the average system load calculated over a given period of time of 1, 5 and 15 minutes (output: x.x x.x x.x)
```bash
set -g @dracula-cpu-display-load true
```

possible nerdfont settings for cpu usage label:
```bash
set -g @dracula-cpu-usage-label " "
```

nerdfont icons to consider:
```bash
   󰍛 󰘚 󰻟 󰻠
```

`set -g @dracula-refresh-rate 5` affects this widget
#### Current working directory - [up](#table-of-contents)
This widget displays the path of the current working directory.
#### Fossil - [up](#table-of-contents)
**TODO**
#### git options - [up](#table-of-contents)
This widget displays info about the current git repository.

Hide details of git changes
```bash
set -g @dracula-git-disable-status true
```

Set symbol to use for when branch is up to date with HEAD
```bash
# default is ✓. Avoid using non unicode characters that bash uses like $, * and !
set -g @dracula-git-show-current-symbol ✓
```

Set symbol to use for when branch diverges from HEAD
```bash
# default is unicode !. Avoid bash special characters
set -g @dracula-git-show-diff-symbol !
```

Set symbol or message to use when the current pane has no git repo
```bash
# default is unicode no message
set -g @dracula-git-no-repo-message ""
```

Hide untracked files from being displayed as local changes
```bash
# default is false
set -g @dracula-git-no-untracked-files true
```

Show remote tracking branch together with diverge/sync state
```bash
# default is false
set -g @dracula-git-show-remote-status true
```

#### gpu-usage options - [up](#table-of-contents)
These widgets display the current computational, ram, and power usage of installed graphics cards.

hardware support:
- full support for NVIDIA gpus on linux.
- partial support for apple m-chips on MacOS.
- support for amd and intel is underway

If your gpu is not recognised, force the script to assume a certain brands.
```bash
set -g @dracula-force-gpu "NVIDIA"
```

To display the used vram in percent (gigabyte is default unit):
```bash
set -g @dracula-gpu-vram-percent true
```

Vram usage is displayed in gigabyte without decimal places per default. To change that behaviour, use the following options with the respective number of decimal places you'd like to get:
```bash
set -g @dracula-gpu-vram-used-accuracy ".2f"
set -g @dracula-gpu-vram-total-accuracy ".1f"
```

To display the power usage in percent (watt is default unit):
```bash
set -g @dracula-gpu-power-percent true
```

Possible nerdfont settings for gpu info labels:
```bash
set -g @dracula-gpu-power-label "󰢮 "
set -g @dracula-gpu-usage-label "󰢮 "
set -g @dracula-gpu-vram-label "󰢮 "
```

nerdfont icons to consider:
```bash
󰢮
```

`set -g @dracula-refresh-rate 5` affects this widget
#### Mercurial options - [up](#table-of-contents)
This widget displays info about the current mercurial repository.

Hide details of hg changes
```bash
set -g @dracula-hg-disable-status true
```

Set symbol to use for when branch is up to date with HEAD
```bash
#default is ✓.Avoid using non unicode characters that bash uses like $, * and !
set -g @dracula-hg-show-current-symbol ✓
```

Set symbol to use for when branch diverges from HEAD
```bash
#default is unicode !.Avoid bash special characters
set -g @dracula-hg-show-diff-symbol !
```

Set symbol or message to use when the current pane has no hg repo
```bash
#default is unicode no message
set -g @dracula-hg-no-repo-message ""
```

Hide untracked files from being displayed as local changes
```bash
#default is false
set -g @dracula-hg-no-untracked-files false
```

#### Kerberos TGT options - [up](#table-of-contents)

Set the principal to check the TGT expiration date for (with or without the REALM)

```
set -g @dracula-krbtgt-principal "principal"
```

#### Kubernetes options - [up](#table-of-contents)

Add prefix label before the context

```bash
set -g @dracula-kubernetes-context-label "Some Label"
```

Hide user from the context string

```
set -g @dracula-kubernetes-hide-user true
```

Hide ARN (show only cluster name) - Available for EKS only (only available for cluster names that are ARNs)

```
set -g @dracula-kubernetes-eks-hide-arn true
```

Extract the account as a prefix to the cluster name - Available for EKS only (only available for cluster names that are ARNs)

```
set -g @dracula-kubernetes-eks-extract-account true
```

#### libre - [up](#table-of-contents)
This script retrieves and displays continuous glucose monitoring (CGM) data from the LibreView API.
It caches the data to minimize API requests and displays the latest glucose level along with a trend indicator in a Tmux status bar.
#### MPC - [up](#table-of-contents)
This widget displays music information provided by mpc.

To format the display format:
```bash
set -g @dracula-mpc-format "%title% - %artist%"
```

`set -g @dracula-refresh-rate 5` affects this widget
#### network - [up](#table-of-contents)
This widget displays one of three states: offline, ethernet connected, or wifi connected.
however, per default **this will only display the wifi you're connected to, if it provides internet access!**

You can use different hosts to ping in order to check for a wifi or wired connection.
If you frequently use networks without internet access, you can use local ip-addresses here to still display the connection.
```bash
set -g @dracula-network-hosts "1.1.1.1 8.8.8.8"
```

Possible nerdfont settings for network info:
```bash
set -g @dracula-network-ethernet-label "󰈀 Eth"
set -g @dracula-network-offline-label "󱍢 "
set -g @dracula-network-wifi-label " "
```

Nerdfont icons to consider:
```
ethernet: 󰈀 󰒪 󰒍 󰌗 󰌘
offline: 󰖪  󱍢
wifi:      󰖩  󰘊 󰒢
```

Known issues:
- If for some reason `iw` is only in the path for root and not the normal user, wifi connections will be considered ethernet connections.
#### network-bandwidth - [up](#table-of-contents)
This widget gives the currently used up and download speeds per second for one interface.

The most common interfaces name are `eth0` for a wired connection and `wlan0` for a wireless connection.
To set a specific network interface you'd like to monitor, used:
```bash
set -g @dracula-network-bandwidth "eno0"
```
To display the interface name alongside the speeds, set:
```bash
set -g @dracula-network-bandwidth-show-interface true
```
Per default, this widget checks the speeds as frequently as it can. to set longer intervals, use the following:
```bash
set -g @dracula-network-bandwidth-interval 5
```

#### network-ping options - [up](#table-of-contents)
This widget displays the current ping to a specific server.

You can configure which server (hostname, IP) you want to ping and at which rate (in seconds). Default is google.com at every 5 seconds.

```bash
set -g @dracula-ping-server "google.com"
set -g @dracula-ping-rate 5
```

#### network vpn - [up](#table-of-contents)
**TODO**

set -g @dracula-network-vpn-verbose true

TODO:
set -g @dracula-network-vpn-label
#### Playerctl format - [up](#table-of-contents)
This widget displays playerctl info.

Set the playerctl metadata format like so:
```bash
set -g @dracula-playerctl-format "►  {{ artist }} - {{ title }}"
```

#### ram-usage options - [up](#table-of-contents)
This widget displays the currently used ram as GB per GB.

Possible nerdfont settings for ram usage:
```bash
set -g @dracula-ram-usage-label " "
```

Nerdfont icons to consider:
```
   󰍛 󰘚
```
#### rpi-temp - [up](#table-of-contents)
**TODO**
#### spotify tui - [up](#table-of-contents)
This widget displays music information provided by spotify-tui. Spotify-tui must be installed to use this widget.

To format the display format:
```bash
set -g @dracula-spotify-tui-format "%f %s %t - %a"
```

To limit the maximum length (0 means unlimited length):
```bash
set -g @dracula-spotify-tui-max-len 30
```

`set -g @dracula-refresh-rate 5` affects this widget
#### ssh-session options - [up](#table-of-contents)
This widget displays the current username@host combination, both of the local machine as well as when connected via ssh.

To output nothing (and maybe hide the widget) when not connected via ssh:
```bash
set -g @dracula-show-ssh-only-when-connected true
```

Show SSH session port:
```bash
set -g @dracula-show-ssh-session-port true
```

nerdfont icons to consider:
```
󰣀
```
#### synchronize-panes options - [up](#table-of-contents)
This widget displays whether the tmux panes are currently synchronised or not.

To change the label:
```bash
set -g @dracula-synchronize-panes-label "Sync"
```

`set -g @dracula-refresh-rate 5` affects this widget
#### terraform - [up](#table-of-contents)
**TODO**

```
set -g @dracula-terraform-label ""
```

`set -g @dracula-refresh-rate 5` affects this widget
#### time options - [up](#table-of-contents)
This widget displays current date and time.

Disable timezone

```bash
set -g @dracula-show-timezone false
```

Swap date to day/month

```bash
set -g @dracula-day-month true
```

Enable military time

```bash
set -g @dracula-military-time true
```

Set custom time format e.g (2023-01-01 14:00)
```bash
set -g @dracula-time-format "%F %R"
```
See [[this page]](https://man7.org/linux/man-pages/man1/date.1.html) for other format symbols.

#### tmux-ram-usage options - [up](#table-of-contents)
This widget displays the ram currently used by tmux.

Possible nerdfont settings for tmux ram usage:
```
@dracula-tmux-ram-usage-label " "
```

Nerdfont icons to consider:
```
   󰍛 󰘚
```
#### weather options - [up](#table-of-contents)
Show weather information for given location.

Switch from default fahrenheit to celsius

```bash
set -g @dracula-show-fahrenheit false
```

Set your location manually

```bash
set -g @dracula-fixed-location "Some City"
```

Hide your location

```bash
set -g @dracula-show-location false
```

#### custom scripts - [up](#table-of-contents)
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