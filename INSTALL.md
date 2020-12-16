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

Customize the status bar by adding any of these lines to your .tmux.conf as desired:  
* Disable battery functionality: `set -g @dracula-show-battery false`
* Disable network functionality: `set -g @dracula-show-network false`
* Disable weather functionality: `set -g @dracula-show-weather false`
* Disable time functionality: `set -g @dracula-show-time false`
* Disable location information: `set -g @dracula-show-location false`
* Switch from default fahrenheit to celsius: `set -g @dracula-show-fahrenheit false`
* Enable powerline symbols: `set -g @dracula-show-powerline true`
* Switch powerline symbols `set -g @dracula-show-left-sep ` for left and `set -g @dracula-show-right-sep ` for right symbol (can set any symbol you like as seperator)
* Enable window flags: `set -g @dracula-show-flags true`
* Adjust the refresh rate for the bar `set -g @dracula-refresh-rate 5` the default is 5, it can accept any number
* Enable military time: `set -g @dracula-military-time true`
* Disable timezone: `set -g @dracula-show-timezone false`
* Switch the left smiley icon `set -g @dracula-show-left-icon session` it can accept `session`, `smiley`, `window`, or any character.
* Add padding to the left smiley icon `set -g @dracula-left-icon-padding` default is 1, it can accept any number and 0 disables padding.
* Enable high contrast pane border: `set -g @dracula-border-contrast true`
* Enable cpu usage: `set -g @dracula-cpu-usage true`
* Enable ram usage: `set -g @dracula-ram-usage true`
* Enable gpu usage: `set -g @dracula-gpu-usage true`
* Swap date to day/month `set -g @dracula-day-month true`
