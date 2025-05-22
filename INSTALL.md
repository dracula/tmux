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

The configuration options are documented on [our GitHub](https://github.com/dracula/tmux/blob/master/docs/CONFIG.md)
