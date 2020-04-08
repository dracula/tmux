### [tmux](https://github.com/tmux/tmux/wiki)

#### Install using tpm

If you are a tpm user, you can install the theme and keep up to date by adding the following to your .tmux.conf file:

	set -g @plugin 'dracula/tmux'

#### Activating theme

1. Make sure  `run -b '~/.tmux/plugins/tpm/tpm'` is at the bottom of your .tmux.conf
2. Run tmux
3. Use the tpm install command: `prefix + I` (default prefix is ctrl+b)

