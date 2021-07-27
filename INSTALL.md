### [tmux](https://github.com/tmux/tmux/wiki)

#### Install using [tpm](https://github.com/tmux-plugins/tpm)

If you are a tpm user, you can install the theme and keep up to date by adding the following to your .tmux.conf file:

	set -g @plugin 'dracula/tmux'

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
			plugin = dracula;
			extraConfig = ''
				set -g @dracula-show-battery false
				set -g @dracula-show-powerline true
				set -g @dracula-refresh-rate 10
			'';
		}
	];

	extraConfig = ''
		set -g mouse on
	'';
};
```

#### Activating theme

1. Make sure  `run -b '~/.tmux/plugins/tpm/tpm'` is at the bottom of your .tmux.conf
2. Run tmux
3. Use the tpm install command: `prefix + I` (default prefix is ctrl+b)

#### Configuration

To enable plugins set up the `@dracula-plugins` option in you `.tmux.conf` file, separate plugin by space.
The order that you define the plugins will be the order on the status bar left to right.

```bash
# available plugins: battery, cpu-usage, gpu-usage, ram-usage, network, network-bandwith, weather, time
set -g @dracula-plugins "cpu-usage gpu-usage ram-usage"
```

For each plugin is possible to customize background and foreground colors

```bash
# available colors: white, gray, dark_gray, light_purple, dark_purple, cyan, green, orange, red, pink, yellow
# set -g @dracula-[plugin-name]-colors "[background] [foreground]"
set -g @dracula-cpu-usage-colors "pink dark_gray"
```

#### Status bar options

Enable powerline symbols

```bash
set -g @dracula-show-powerline true
```

Switch powerline symbols

```bash
# for left
set -g @dracula-show-left-sep 

# for right symbol (can set any symbol you like as seperator)
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
# it can accept `session`, `smiley`, `window`, or any character.
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

#### cpu-usage options

Customize label

```bash
set -g @dracula-cpu-usage-label "CPU"
```

#### gpu-usage options

Customize label

```bash
set -g @dracula-gpu-usage-label "GPU"
```

#### ram-usage options

Customize label

```bash
set -g @dracula-ram-usage-label "RAM"
```

#### time options

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

#### git options

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


#### weather options

Switch from default fahrenheit to celsius

```bash
set -g @dracula-show-fahrenheit false
```

