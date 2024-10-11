# overriding widget colors
widget color options with default values - sorted alphabetically:
```
set -g @dracula-attached-clients-colors "cyan dark_gray"
set -g @dracula-battery-colors "pink dark_gray"
set -g @dracula-continuum-colors "cyan dark_gray"
set -g @dracula-cpu-usage-colors "orange dark_gray"
set -g @dracula-custom-plugin-colors "cyan dark_gray"
set -g @dracula-cwd-colors "dark_gray white"
set -g @dracula-fossil-colors "green dark_gray"
set -g @dracula-git-colors "green dark_gray"
set -g @dracula-gpu-power-draw-colors "green dark_gray"
set -g @dracula-gpu-ram-usage-colors "cyan dark_gray"
set -g @dracula-gpu-usage-colors "pink dark_gray"
set -g @dracula-hg-colors "green dark_gray"
set -g @dracula-kubernetes-context-colors "cyan dark_gray"
set -g @dracula-libre-colors "white dark_gray"
set -g @dracula-mpc-colors "green dark_gray"
set -g @dracula-network-bandwidth-colors "cyan dark_gray"
set -g @dracula-network-colors "cyan dark_gray"
set -g @dracula-network-ping-colors "cyan dark_gray"
set -g @dracula-network-vpn-colors "cyan dark_gray"
set -g @dracula-playerctl-colors "green dark_gray"
set -g @dracula-ram-usage-colors "cyan dark_gray"
set -g @dracula-spotify-tui-colors "green dark_gray"
set -g @dracula-ssh-session-colors "green dark_gray"
set -g @dracula-synchronize-panes-colors "cyan dark_gray"
set -g @dracula-terraform-colors "light_purple dark_gray"
set -g @dracula-time-colors "dark_purple white"
set -g @dracula-tmux-ram-usage-colors "cyan dark_gray"
set -g @dracula-weather-colors "orange dark_gray"
```

# overriding color variables
this requires an extra `.sh` file which specifies color variables and their respective values. it can be used to override and also extend the dracula color pallette.

if your tmux config is in `~/.config/tmux/`, then consider putting the color variables into `~/.config/tmux/colors.sh`, with the matching option `set -g @dracula-colors "~/.config/tmux/colors.sh"` in your tmux config.
alternatively, if your tmux config is `~/.tmux.conf`, then consider putting the color variables into `~/.tmux_colors.sh`, with the matching option `set -g @dracula-colors "~/.tmux_colors.sh"` in your tmux config.

for a quick setup, fill the file with the following contents:
```
# Dracula Color Pallette
white="#f8f8f2"
gray="#44475a"
dark_gray="#282a36"
light_purple="#bd93f9"
dark_purple="#6272a4"
cyan="#8be9fd"
green="#50fa7b"
orange="#ffb86c"
red="#ff5555"
pink="#ff79c6"
yellow="#f1fa8c"
```
## plug and play themes
as part of this directory there are some plug and play themes with explanations on how to use them:
- [catppuccin](/docs/color_theming/catppuccin.md)
- [gruvbox](/docs/color_theming/gruvbox.md)
