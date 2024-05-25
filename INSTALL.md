### [tmux](https://github.com/tmux/tmux/wiki)

#### Install using [tpm](https://github.com/tmux-plugins/tpm)

If you are a tpm user, you can install the theme and keep up to date by adding the following to your .tmux.conf file:

    set -g @plugin 'Nybkox/tmux-kanagawa'

Add any configuration options below this line in your tmux config.

#### Install with [Nix](https://nixos.org)

If you're using [home-manager](https://github.com/nix-community/home-manager), an example config would look similar to this:
Then run `home-manager switch`, the `Activating theme` section doesn't apply here.

```nix
programs.tmux = {
	enable = true;
	clock24 = true;
	plugins = with pkgs.tmuxPlugins; [
		sensible
		yank
		{
			plugin = kanagawa;
			extraConfig = ''
				set -g @kanagawa-show-battery false
				set -g @kanagawa-show-powerline true
				set -g @kanagawa-refresh-rate 10
				set -g @kanagawa-show-battery false
				set -g @kanagawa-show-powerline true
				set -g @kanagawa-refresh-rate 10
			'';
		}
	];

	extraConfig = ''
		set -g mouse on
	'';
};
```

#### Activating theme

1. Make sure `run -b '~/.tmux/plugins/tpm/tpm'` is at the bottom of your .tmux.conf
2. Run tmux
3. Use the tpm install command: `prefix + I` (default prefix is ctrl+b)

#### Configuration

To enable plugins set up the `@kanagawa-plugins` option in you `.tmux.conf` file, separate plugin by space.
The order that you define the plugins will be the order on the status bar left to right.

```bash
# available plugins: battery, cpu-usage, git, gpu-usage, ram-usage, tmux-ram-usage, network, network-bandwidth, network-ping, ssh-session, attached-clients, network-vpn, weather, time, mpc, spotify-tui, playerctl, kubernetes-context, synchronize-panes
set -g @kanagawa-plugins "cpu-usage gpu-usage ram-usage"
```

For each plugin is possible to customize background and foreground colors

```bash
# available colors: white, gray, dark_gray, light_purple, dark_purple, cyan, green, orange, red, pink, yellow
# set -g @kanagawa-[plugin-name]-colors "[background] [foreground]"
set -g @kanagawa-cpu-usage-colors "pink dark_gray"
```

#### Status bar options

Enable powerline symbols

```bash
set -g @kanagawa-show-powerline true
```

Switch powerline symbols

```bash
# for left
set -g @kanagawa-show-left-sep 

# for right symbol (can set any symbol you like as separator)
set -g @kanagawa-show-right-sep 
```

Enable window flags

```bash
set -g @kanagawa-show-flags true
```

Adjust the refresh rate for the status bar

```bash
# the default is 5, it can accept any number
set -g @kanagawa-refresh-rate 5
```

Switch the left smiley icon

```bash
# it can accept `hostname` (full hostname), `session`, `shortname` (short name), `smiley`, `window`, or any character.
set -g @kanagawa-show-left-icon session
```

Add padding to the left smiley icon

```bash
# default is 1, it can accept any number and 0 disables padding.
set -g @kanagawa-left-icon-padding 1
```

Enable high contrast pane border

```bash
set -g @kanagawa-border-contrast true
```

Hide empty plugins

```bash
set -g @kanagawa-show-empty-plugins false
```

#### cpu-usage options

Customize label

```bash
set -g @kanagawa-cpu-usage-label "CPU"
```

Show system load average instead of CPU usage percentage (default)

```bash
set -g @kanagawa-cpu-display-load true
```

CPU usage percentage (default) - in percentage (output: %)
Load average – is the average system load calculated over a given period of time of 1, 5 and 15 minutes (output: x.x x.x x.x)

#### battery options

Customize label

```bash
set -g @kanagawa-battery-label "Battery"
```

#### gpu-usage options

Note, currently only the Linux NVIDIA Proprietary drivers are supported. Nouveau and AMD Graphics Cards support are still under development.

Customize label

```bash
set -g @kanagawa-gpu-usage-label "GPU"
```

#### ram-usage options

Customize label

```bash
set -g @kanagawa-ram-usage-label "RAM"
```

#### tmux-ram-usage options

Customize label

```bash
set -g @kanagawa-tmux-ram-usage-label "MEM"
```

#### network-bandwidth

You can configure which network interface you want to view the bandwidth,
Displaying of the interface name, The interval between each bandwidth update.
The most common interfaces name are `eth0` for a wired connection and `wlan0` for a wireless connection.

```bash
set -g @kanagawa-network-bandwidth eth0
set -g @kanagawa-network-bandwidth-interval 0
set -g @kanagawa-network-bandwidth-show-interface true
```

#### network-ping options

You can configure which server (hostname, IP) you want to ping and at which rate (in seconds). Default is google.com at every 5 seconds.

```bash
set -g @kanagawa-ping-server "google.com"
set -g @kanagawa-ping-rate 5
```

### ssh-session options

Show SSH session port

```bash
set -g @kanagawa-show-ssh-session-port true
```

#### time options

Disable timezone

```bash
set -g @kanagawa-show-timezone false
```

Swap date to day/month

```bash
set -g @kanagawa-day-month true
```

Enable military time

```bash
set -g @kanagawa-military-time true
```

Set custom time format e.g (2023-01-01 14:00)

```bash
set -g @kanagawa-time-format "%F %R"
```

See [[this page]](https://man7.org/linux/man-pages/man1/date.1.html) for other format symbols.

#### git options

Hide details of git changes

```bash
set -g @kanagawa-git-disable-status true
```

Set symbol to use for when branch is up to date with HEAD

```bash
# default is ✓. Avoid using non unicode characters that bash uses like $, * and !
set -g @kanagawa-git-show-current-symbol ✓
```

Set symbol to use for when branch diverges from HEAD

```bash
# default is unicode !. Avoid bash special characters
set -g @kanagawa-git-show-diff-symbol !
```

Set symbol or message to use when the current pane has no git repo

```bash
# default is unicode no message
set -g @kanagawa-git-no-repo-message ""
```

Hide untracked files from being displayed as local changes

```bash
# default is false
set -g @kanagawa-git-no-untracked-files true
```

Show remote tracking branch together with diverge/sync state

```bash
# default is false
set -g @kanagawa-git-show-remote-status true
```

#### hg options

Hide details of hg changes

```bash
set -g @kanagawa-hg-disable-status true
```

Set symbol to use for when branch is up to date with HEAD

```bash
#default is ✓.Avoid using non unicode characters that bash uses like $, * and !
set -g @kanagawa-hg-show-current-symbol ✓
```

Set symbol to use for when branch diverges from HEAD

```bash
#default is unicode !.Avoid bash special characters
set -g @kanagawa-hg-show-diff-symbol !
```

Set symbol or message to use when the current pane has no hg repo

```bash
#default is unicode no message
set -g @kanagawa-hg-no-repo-message ""
```

Hide untracked files from being displayed as local changes

```bash
#default is false
set -g @kanagawa-hg-no-untracked-files false
```

#### weather options

Switch from default fahrenheit to celsius

```bash
set -g @kanagawa-show-fahrenheit false
```

Set your location manually

```bash
set -g @kanagawa-fixed-location "Some City"
```

Hide your location

```bash
set -g @kanagawa-show-location false
```

#### synchronize-panes options

Customize label

```bash
set -g @kanagawa-synchronize-panes-label "Sync"
```

#### attached-clients options

Set the minimum number of clients to show (otherwise, show nothing)

```bash
set -g @kanagawa-clients-minimum 1
```

Set the label when there is one client, or more than one client

```bash
set -g @kanagawa-clients-singular client
set -g @kanagawa-clients-plural clients
```

#### Kubernetes options

Add prefix label before the context

```bash
set -g @kanagawa-kubernetes-context-label "Some Label"
```

Hide user from the context string

```bash
set -g @kanagawa-kubernetes-hide-user true
```

Hide ARN (show only cluster name) - Available for EKS only (only available for cluster names that are ARNs)

```bash
set -g @kanagawa-kubernetes-eks-hide-arn true
```

Extract the account as a prefix to the cluster name - Available for EKS only (only available for cluster names that are ARNs)

```bash
set -g @kanagawa-kubernetes-eks-extract-account true
```

#### continuum options

Set the output mode. Options are:
- **countdown**: Show a T- countdown to the next save (default)
- **time**: Show the time since the last save
- **alert**: Hide output if no save has been performed recently
- **interval**: Show the continuum save interval

```bash
set -g @kanagawa-continuum-mode countdown
````

Show if the last save was performed less than 60 seconds ago (default threshold is 15 seconds)

```bash
set -g @kanagawa-continuum-time-threshold 60
```

#### Playerctl format

Set the playerctl metadata format

```
set -g @kanagawa-playerctl-format "►  {{ artist }} - {{ title }}"
```
