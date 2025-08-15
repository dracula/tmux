#!/usr/bin/env bash
# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $current_dir/utils.sh

main() {
  # set configuration option variables
  show_krbtgt_label=$(get_tmux_option "@dracula-krbtgt-context-label" "")
  krbtgt_principal=$(get_tmux_option "@dracula-krbtgt-principal" "")
  show_kubernetes_context_label=$(get_tmux_option "@dracula-kubernetes-context-label" "")
  show_only_kubernetes_context=$(get_tmux_option "@dracula-show-only-kubernetes-context" false)
  eks_hide_arn=$(get_tmux_option "@dracula-kubernetes-eks-hide-arn" false)
  eks_extract_account=$(get_tmux_option "@dracula-kubernetes-eks-extract-account" false)
  hide_kubernetes_user=$(get_tmux_option "@dracula-kubernetes-hide-user" false)
  terraform_label=$(get_tmux_option "@dracula-terraform-label" "")
  show_fahrenheit=$(get_tmux_option "@dracula-show-fahrenheit" true)
  show_location=$(get_tmux_option "@dracula-show-location" true)
  fixed_location=$(get_tmux_option "@dracula-fixed-location")
  show_powerline=$(get_tmux_option "@dracula-show-powerline" false)
  transparent_powerline_bg=$(get_tmux_option "@dracula-transparent-powerline-bg" false)
  show_flags=$(get_tmux_option "@dracula-show-flags" false)
  show_left_icon=$(get_tmux_option "@dracula-show-left-icon" smiley)
  show_left_icon_padding=$(get_tmux_option "@dracula-left-icon-padding" 1)
  show_military=$(get_tmux_option "@dracula-military-time" false)
  timezone=$(get_tmux_option "@dracula-set-timezone" "")
  show_timezone=$(get_tmux_option "@dracula-show-timezone" true)
  show_left_sep=$(get_tmux_option "@dracula-show-left-sep" )
  show_right_sep=$(get_tmux_option "@dracula-show-right-sep" )
  show_edge_icons=$(get_tmux_option "@dracula-show-edge-icons" false)
  show_inverse_divider=$(get_tmux_option "@dracula-inverse-divider" )
  show_border_contrast=$(get_tmux_option "@dracula-border-contrast" false)
  show_day_month=$(get_tmux_option "@dracula-day-month" false)
  show_refresh=$(get_tmux_option "@dracula-refresh-rate" 5)
  show_synchronize_panes_label=$(get_tmux_option "@dracula-synchronize-panes-label" "Sync")
  time_format=$(get_tmux_option "@dracula-time-format" "")
  show_ssh_session_port=$(get_tmux_option "@dracula-show-ssh-session-port" false)
  show_libreview=$(get_tmux_option "@dracula-show-libreview" false)
  show_empty_plugins=$(get_tmux_option "@dracula-show-empty-plugins" true)
  left_pad=$(get_tmux_option "@dracula-left-pad" " ")
  right_pad=$(get_tmux_option "@dracula-right-pad" " ")

  narrow_mode=$(get_tmux_option "@dracula-narrow-mode" false)
  if $narrow_mode; then
    IFS=' ' read -r -a plugins <<< $(get_tmux_option "@dracula-narrow-plugins" "compact-alt battery network weather")
  else
    IFS=' ' read -r -a plugins <<< $(get_tmux_option "@dracula-plugins" "battery network weather")
  fi

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
  purple="#b166cc"
  pink="#ff79c6"
  yellow="#f1fa8c"

  # Override default colors and possibly add more
  colors="$(get_tmux_option "@dracula-colors" "")"
  if [ -n "$colors" ]; then
    eval "$colors"
  fi

  # Set transparency variables - Colors and window dividers
  if $transparent_powerline_bg; then
	bg_color="default"
	if $show_edge_icons; then
	  window_sep_fg=${dark_purple}
	  window_sep_bg=default
	  window_sep="$show_right_sep"
	else
	  window_sep_fg=${dark_purple}
	  window_sep_bg=default
	  window_sep="$show_inverse_divider"
	fi
  else
    bg_color=${gray}
    if $show_edge_icons; then
      window_sep_fg=${dark_purple}
      window_sep_bg=${gray}
      window_sep="$show_inverse_divider"
    else
      window_sep_fg=${gray}
      window_sep_bg=${dark_purple}
      window_sep="$show_left_sep"
    fi
  fi

  # Handle left icon configuration
  case $show_left_icon in
    smiley)
      left_icon="☺";;
    session)
      left_icon="#S";;
    window)
      left_icon="#W";;
    hostname)
      left_icon="#H";;
    shortname)
      left_icon="#h";;
    *)
      left_icon=$show_left_icon;;
  esac

  # Handle left icon padding
  padding=""
  if [ "$show_left_icon_padding" -gt "0" ]; then
    padding="$(printf '%*s' $show_left_icon_padding)"
  fi
  left_icon="$left_icon$padding"

  # Handle powerline option
  if $show_powerline; then
    right_sep="$show_right_sep"
    left_sep="$show_left_sep"
  fi

  # Set timezone unless hidden by configuration
  if [[ -z "$timezone" ]]; then
    case $show_timezone in
      false)
        timezone="";;
      true)
        timezone="#(date +%Z)";;
    esac
  fi

  case $show_flags in
    false)
      flags=""
      current_flags="";;
    true)
      flags="$(get_tmux_option "@dracula-window-flags" "#{?window_flags,#[fg=${dark_purple}]#{window_flags},}")"
      current_flags="$(get_tmux_option "@dracula-window-current-flags" "#{?window_flags,#[fg=${light_purple}]#{window_flags},}")"
  esac

  # sets refresh interval to every 5 seconds
  tmux set-option -g status-interval $show_refresh

  # set the prefix + t time format
  if $show_military; then
    tmux set-option -g clock-mode-style 24
  else
    tmux set-option -g clock-mode-style 12
  fi

  # set length
  tmux set-option -g status-left-length 100
  tmux set-option -g status-right-length 100

  # pane border styling
  if $show_border_contrast; then
    tmux set-option -g pane-active-border-style "fg=${light_purple}"
  else
    tmux set-option -g pane-active-border-style "fg=${dark_purple}"
  fi
  tmux set-option -g pane-border-style "fg=${gray}"

  # message styling
  tmux set-option -g message-style "bg=${gray},fg=${white}"

  # status bar
  tmux set-option -g status-style "bg=${bg_color},fg=${white}"

  # Status left
  if $show_powerline; then
    if $show_edge_icons; then
      tmux set-option -g status-left "#[bg=${bg_color},fg=${green},bold]#{?client_prefix,#[fg=${yellow}],}${show_right_sep}#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} ${left_icon} #[fg=${green},bg=${bg_color}]#{?client_prefix,#[fg=${yellow}],}${left_sep} "
    else
      tmux set-option -g status-left "#[bg=${dark_gray},fg=${green}]#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} ${left_icon} #[fg=${green},bg=${bg_color}]#{?client_prefix,#[fg=${yellow}],}${left_sep}"
    fi
    powerbg=${bg_color}
  else
    tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} ${left_icon}"
  fi

  # Status right
  tmux set-option -g status-right ""

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

    elif [ $plugin = "compact-alt" ]; then
      IFS=' ' read -r -a colors  <<< $(get_tmux_option "@dracula-compact-alt-colors" "dark_gray white")
      tmux set-option -g status-right-length 250
      script="#($current_dir/compact_alt.sh)"

    elif [ $plugin = "cwd" ]; then
      IFS=' ' read -r -a colors  <<< $(get_tmux_option "@dracula-cwd-colors" "dark_gray white")
      tmux set-option -g status-right-length 250
      script="#($current_dir/cwd.sh)"

    elif [ $plugin = "fossil" ]; then
      IFS=' ' read -r -a colors  <<< $(get_tmux_option "@dracula-fossil-colors" "green dark_gray")
      tmux set-option -g status-right-length 250
      script="#($current_dir/fossil.sh)"

    elif [ $plugin = "git" ]; then
      IFS=' ' read -r -a colors  <<< $(get_tmux_option "@dracula-git-colors" "green dark_gray")
      tmux set-option -g status-right-length 250
      script="#($current_dir/git.sh)"

    elif [ $plugin = "hg" ]; then
      IFS=' ' read -r -a colors  <<< $(get_tmux_option "@dracula-hg-colors" "green dark_gray")
      tmux set-option -g status-right-length 250
      script="#($current_dir/hg.sh)"

    elif [ $plugin = "battery" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-battery-colors" "pink dark_gray")
      script="#($current_dir/battery.sh)"

    elif [ $plugin = "gpu-usage" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-gpu-usage-colors" "pink dark_gray")
      script="#($current_dir/gpu_usage.sh)"

    elif [ $plugin = "gpu-ram-usage" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-gpu-ram-usage-colors" "cyan dark_gray")
      script="#($current_dir/gpu_ram_info.sh)"

    elif [ $plugin = "gpu-power-draw" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-gpu-power-draw-colors" "green dark_gray")
      script="#($current_dir/gpu_power.sh)"

    elif [ $plugin = "cpu-usage" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-cpu-usage-colors" "orange dark_gray")
      script="#($current_dir/cpu_info.sh)"

    elif [ $plugin = "ram-usage" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-ram-usage-colors" "cyan dark_gray")
      script="#($current_dir/ram_info.sh)"

    elif [ $plugin = "tmux-ram-usage" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-tmux-ram-usage-colors" "cyan dark_gray")
      script="#($current_dir/tmux_ram_info.sh)"

    elif [ $plugin = "network" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-network-colors" "cyan dark_gray")
      script="#($current_dir/network.sh)"

    elif [ $plugin = "network-bandwidth" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-network-bandwidth-colors" "cyan dark_gray")
      tmux set-option -g status-right-length 250
      script="#($current_dir/network_bandwidth.sh)"

    elif [ $plugin = "network-ping" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-network-ping-colors" "cyan dark_gray")
      script="#($current_dir/network_ping.sh)"

    elif [ $plugin = "network-vpn" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-network-vpn-colors" "cyan dark_gray")
      script="#($current_dir/network_vpn.sh)"

    elif [ $plugin = "attached-clients" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-attached-clients-colors" "cyan dark_gray")
      script="#($current_dir/attached_clients.sh)"


     elif [ $plugin = "mac-player" ]; then
      IFS=' ' read -r -a colors  <<< $(get_tmux_option "@dracula-mac-player-colors" "purple dark_gray")
      script="#($current_dir/mac-player.sh)"

    elif [ $plugin = "mpc" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-mpc-colors" "green dark_gray")
      script="#($current_dir/mpc.sh)"

    elif [ $plugin = "spr" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-spr-colors" "green dark_gray")
      script="#($current_dir/spr.sh)"

    elif [ $plugin = "spotify-tui" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-spotify-tui-colors" "green dark_gray")
      script="#($current_dir/spotify-tui.sh)"

    elif [ $plugin = "krbtgt" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-krbtgt-colors" "cyan dark_gray")
      script="#($current_dir/krbtgt.sh $krbtgt_principal $show_krbtgt_label)"

    elif [ $plugin = "playerctl" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-playerctl-colors" "green dark_gray")
      script="#($current_dir/playerctl.sh)"

    elif [ $plugin = "kubernetes-context" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-kubernetes-context-colors" "cyan dark_gray")
      script="#($current_dir/kubernetes_context.sh $eks_hide_arn $eks_extract_account $hide_kubernetes_user $show_only_kubernetes_context $show_kubernetes_context_label)"

    elif [ $plugin = "terraform" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-terraform-colors" "light_purple dark_gray")
      script="#($current_dir/terraform.sh $terraform_label)"

    elif [ $plugin = "continuum" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-continuum-colors" "cyan dark_gray")
      script="#($current_dir/continuum.sh)"

    elif [ $plugin = "weather" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-weather-colors" "orange dark_gray")
      script="#($current_dir/weather_wrapper.sh $show_fahrenheit $show_location '$fixed_location')"

    elif [ $plugin = "time" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-time-colors" "dark_purple white")
      if [ -n "$time_format" ]; then
        script=${time_format}
      else
        if $show_day_month && $show_military ; then # military time and dd/mm
          script="%a %d/%m %R ${timezone} "
        elif $show_military; then # only military time
          script="%R ${timezone} "
        elif $show_day_month; then # only dd/mm
          script="%a %d/%m %I:%M %p ${timezone} "
        else
          script="%a %m/%d %I:%M %p ${timezone} "
        fi
      fi
    elif [ $plugin = "synchronize-panes" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-synchronize-panes-colors" "cyan dark_gray")
      script="#($current_dir/synchronize_panes.sh $show_synchronize_panes_label)"

    elif [ $plugin = "libreview" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-libre-colors" "white dark_gray")
      script="#($current_dir/libre.sh $show_libreview)"

    elif [ $plugin = "ssh-session" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-ssh-session-colors" "green dark_gray")
      script="#($current_dir/ssh_session.sh $show_ssh_session_port)"

    elif [ $plugin = "network-public-ip" ]; then
      IFS=' ' read -r -a colors <<<$(get_tmux_option "@dracula-network-public-ip-colors" "cyan dark_gray")
      script="#($current_dir/network-public-ip.sh)"

    elif [ $plugin = "sys-temp" ]; then
      IFS=' ' read -r -a colors <<< $(get_tmux_option "@dracula-sys-temp-colors" "green dark_gray")
      script="#($current_dir/sys_temp.sh)"

    elif [ $plugin = "cpu-arch" ]; then
      IFS=$' ' read -r -a colors <<< $(get_tmux_option "@dracula-cpu-arch-colors" "default default")
      script="#($current_dir/cpu_arch.sh)"

    elif [ $plugin = "uptime" ]; then
      IFS=$' ' read -r -a colors <<< $(get_tmux_option "@dracula-uptime-colors" "default default")
      script="#($current_dir/uptime.sh)"

    else
      continue
    fi

    # edge styling
    if $show_edge_icons; then
      right_edge_icon="#[bg=${bg_color},fg=${!colors[0]}]${show_left_sep}"
      background_color=${bg_color}
    else
      background_color=${powerbg}
    fi

    # padding
    pad_script="$left_pad$script$right_pad"

    if $show_powerline; then
      if $show_empty_plugins; then
        tmux set-option -ga status-right " #[fg=${!colors[0]},bg=${background_color},nobold,nounderscore,noitalics]${right_sep}#[fg=${!colors[1]},bg=${!colors[0]}]$pad_script$right_edge_icon"
      else
        tmux set-option -ga status-right "#{?#{==:$script,},,#[fg=${!colors[0]},nobold,nounderscore,noitalics]${right_sep}#[fg=${!colors[1]},bg=${!colors[0]}]$pad_script$right_edge_icon}"
    fi
      powerbg=${!colors[0]}
    else
      if $show_empty_plugins; then
        tmux set-option -ga status-right "#[fg=${!colors[1]},bg=${!colors[0]}]$pad_script"
      else
        tmux set-option -ga status-right "#{?#{==:$script,},,#[fg=${!colors[1]},bg=${!colors[0]}]$pad_script}"
      fi
    fi

  done

  # Window option
  if $show_powerline; then
    tmux set-window-option -g window-status-current-format "#[fg=${window_sep_fg},bg=${window_sep_bg}]${window_sep}#[fg=${white},bg=${dark_purple}] #I #W${current_flags} #[fg=${dark_purple},bg=${bg_color}]${left_sep}"
  else
    tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I #W${current_flags} "
  fi

  tmux set-window-option -g window-status-format "#[fg=${white}]#[bg=${bg_color}] #I #W${flags}"
  tmux set-window-option -g window-status-activity-style "bold"
  tmux set-window-option -g window-status-bell-style "bold"
}

# run main function
main
