# widget color options

set -g @dracula-custom-plugin-colors "cyan dark_gray"
set -g @dracula-cwd-colors "dark_gray white"
set -g @dracula-fossil-colors "green dark_gray"
set -g @dracula-git-colors "green dark_gray"
set -g @dracula-hg-colors "green dark_gray"
set -g @dracula-battery-colors "pink dark_gray"
set -g @dracula-gpu-usage-colors "pink dark_gray"
set -g @dracula-gpu-ram-usage-colors "cyan dark_gray"
set -g @dracula-gpu-power-draw-colors "green dark_gray"
set -g @dracula-cpu-usage-colors "orange dark_gray"
set -g @dracula-ram-usage-colors "cyan dark_gray"
set -g @dracula-tmux-ram-usage-colors "cyan dark_gray"
set -g @dracula-network-colors "cyan dark_gray"
set -g @dracula-network-bandwidth-colors "cyan dark_gray"
set -g @dracula-network-ping-colors "cyan dark_gray"
set -g @dracula-network-vpn-colors "cyan dark_gray"
set -g @dracula-attached-clients-colors "cyan dark_gray"
set -g @dracula-mpc-colors "green dark_gray"
set -g @dracula-spotify-tui-colors "green dark_gray"
set -g @dracula-playerctl-colors "green dark_gray"
set -g @dracula-kubernetes-context-colors "cyan dark_gray"
set -g @dracula-terraform-colors "light_purple dark_gray"
set -g @dracula-continuum-colors "cyan dark_gray"
set -g @dracula-weather-colors "orange dark_gray"
set -g @dracula-time-colors "dark_purple white"
set -g @dracula-synchronize-panes-colors "cyan dark_gray"
set -g @dracula-libre-colors "white dark_gray"
set -g @dracula-ssh-session-colors "green dark_gray"


# overriding colors
if your tmux config is in `~/.config/tmux/`, then consider using the following:
`set -g @dracula-colors "~/.config/tmux/colors.sh"`

for a quick setup, fill the file with the following contents:
```
# simple catppuccin Color Pallette
pink='#cba6f7'
orange='#fab387'
yellow='#f9e2af'
green='#a6e3a1'
cyan='#89dceb'
light_purple='#b4befe'
white='#cdd6f4'
dark_gray='#313244'
red='#f38ba8'
gray='#45475a'
dark_purple='#6c7086'
```
