  # set configuration option variables
  show_kubernetes_context_label=$(get_tmux_option "@dracula-kubernetes-context-label" "")
  eks_hide_arn=$(get_tmux_option "@dracula-kubernetes-eks-hide-arn" false)
  eks_extract_account=$(get_tmux_option "@dracula-kubernetes-eks-extract-account" false)
  hide_kubernetes_user=$(get_tmux_option "@dracula-kubernetes-hide-user" false)
  terraform_label=$(get_tmux_option "@dracula-terraform-label" "")
  show_fahrenheit=$(get_tmux_option "@dracula-show-fahrenheit" true)
  show_location=$(get_tmux_option "@dracula-show-location" true)
  fixed_location=$(get_tmux_option "@dracula-fixed-location")
  show_powerline=$(get_tmux_option "@dracula-show-powerline" false)
  show_flags=$(get_tmux_option "@dracula-show-flags" false)
  show_left_icon=$(get_tmux_option "@dracula-show-left-icon" smiley)
  show_left_icon_padding=$(get_tmux_option "@dracula-left-icon-padding" 1)
  show_military=$(get_tmux_option "@dracula-military-time" false)
  timezone=$(get_tmux_option "@dracula-set-timezone" "")
  show_timezone=$(get_tmux_option "@dracula-show-timezone" true)
  show_left_sep=$(get_tmux_option "@dracula-show-left-sep" )
  show_right_sep=$(get_tmux_option "@dracula-show-right-sep" )
  show_border_contrast=$(get_tmux_option "@dracula-border-contrast" false)
  show_day_month=$(get_tmux_option "@dracula-day-month" false)
  show_refresh=$(get_tmux_option "@dracula-refresh-rate" 5)
  show_synchronize_panes_label=$(get_tmux_option "@dracula-synchronize-panes-label" "Sync")
  time_format=$(get_tmux_option "@dracula-time-format" "")
  show_ssh_session_port=$(get_tmux_option "@dracula-show-ssh-session-port" false)
  show_libreview=$(get_tmux_option "@dracula-show-libreview" false)
  IFS=' ' read -r -a plugins <<< $(get_tmux_option "@dracula-plugins" "battery network weather")
  show_empty_plugins=$(get_tmux_option "@dracula-show-empty-plugins" true)

## widget colours
```bash
set -g "@dracula-cwd-colors" "dark_gray white"
set -g "@dracula-fossil-colors" "green dark_gray"
set -g "@dracula-git-colors" "green dark_gray"
set -g "@dracula-hg-colors" "green dark_gray"
set -g "@dracula-battery-colors" "pink dark_gray"
set -g "@dracula-gpu-usage-colors" "pink dark_gray"
set -g "@dracula-gpu-ram-usage-colors" "cyan dark_gray"
set -g "@dracula-gpu-power-draw-colors" "green dark_gray"
set -g "@dracula-cpu-usage-colors" "orange dark_gray"
set -g "@dracula-ram-usage-colors" "cyan dark_gray"
set -g "@dracula-tmux-ram-usage-colors" "cyan dark_gray"
set -g "@dracula-network-colors" "cyan dark_gray"
set -g "@dracula-network-bandwidth-colors" "cyan dark_gray"
set -g "@dracula-network-ping-colors" "cyan dark_gray"
set -g "@dracula-network-vpn-colors" "cyan dark_gray"
set -g "@dracula-attached-clients-colors" "cyan dark_gray"
set -g "@dracula-mpc-colors" "green dark_gray"
set -g "@dracula-spotify-tui-colors" "green dark_gray"
set -g "@dracula-playerctl-colors" "green dark_gray"
set -g "@dracula-kubernetes-context-colors" "cyan dark_gray"
set -g "@dracula-terraform-colors" "light_purple dark_gray"
set -g "@dracula-continuum-colors" "cyan dark_gray"
set -g "@dracula-weather-colors" "orange dark_gray"
set -g "@dracula-time-colors" "dark_purple white"
set -g "@dracula-synchronize-panes-colors" "cyan dark_gray"
set -g "@dracula-libre-colors" "white dark_gray"
set -g "@dracula-ssh-session-colors" "green dark_gray"
```

