# drac to cat

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


alternatively use the full catppuccin color palette and customise the flags accordingly

# catppuccin Color Pallette

# TODO: check em all
Rosewater='#f5e0dc'
Flamingo='#f2cdcd'
Pink='#f5c2e7'
Mauve='#cba6f7' # replace pink
Red='#f38ba8'
Maroon='#eba0ac'
Peach='#fab387' # replacing orange
Yellow='#f9e2af' # replacing yellow
Green='#a6e3a1' # replacing green
Teal='#94e2d5'
Sky='#89dceb' # replacing cyan
Sapphire='#74c7ec'
Blue='#89b4fa' # replacing dark_purple
Lavender='#b4befe' # replacing light_purple
Text='#cdd6f4' # replacing white
Subtext1='#bac2de'
Subtext0='#a6adc8'
Overlay2='#9399b2'
Overlay1='#7f849c'
Overlay0='#6c7086'
Surface2='#585b70'
Surface1='#45475a'
Surface0='#313244' # replace dark_gray
Base='#1e1e2e'
Mantle='#181825'
Crust='#11111b'

# TODO: check em all
set -g "@dracula-cwd-colors" "Surface0 Text"
set -g "@dracula-fossil-colors" "Green Surface0"
set -g "@dracula-git-colors" "Green Surface0"
set -g "@dracula-hg-colors" "Green Surface0"
set -g "@dracula-battery-colors" "Mauve Surface0"
set -g "@dracula-gpu-usage-colors" "Mauve Surface0"
set -g "@dracula-gpu-ram-usage-colors" "Sky Surface0"
set -g "@dracula-gpu-power-draw-colors" "Green Surface0"
set -g "@dracula-cpu-usage-colors" "orange Surface0"
set -g "@dracula-ram-usage-colors" "Sky Surface0"
set -g "@dracula-tmux-ram-usage-colors" "Sky Surface0"
set -g "@dracula-network-colors" "Sky Surface0"
set -g "@dracula-network-bandwidth-colors" "Sky Surface0"
set -g "@dracula-network-ping-colors" "Sky Surface0"
set -g "@dracula-network-vpn-colors" "Sky Surface0"
set -g "@dracula-attached-clients-colors" "Sky Surface0"
set -g "@dracula-mpc-colors" "Green Surface0"
set -g "@dracula-spotify-tui-colors" "Green Surface0"
set -g "@dracula-playerctl-colors" "Green Surface0"
set -g "@dracula-kubernetes-context-colors" "Sky Surface0"
set -g "@dracula-terraform-colors" "Lavender Surface0"
set -g "@dracula-continuum-colors" "Sky Surface0"
set -g "@dracula-weather-colors" "orange Surface0"
set -g "@dracula-time-colors" "dark_purple white"
set -g "@dracula-synchronize-panes-colors" "Sky Surface0"
set -g "@dracula-libre-colors" "Text Surface0"
set -g "@dracula-ssh-session-colors" "Green Surface0"
