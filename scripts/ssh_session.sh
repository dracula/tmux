#!/usr/bin/env bash

# setting the locale, some users have issues with different locales, this forces the correct one
export LC_ALL=en_US.UTF-8

show_ssh_session_port=$1

parse_ssh_port() {
  # Get port from connection
  local port=$(echo $1|grep -Eo '\-p\s*([0-9]+)'|sed 's/-p\s*//')

  if [ -z $port ]; then
    local port=22
  fi

  echo $port
}

search_ssh_user() {
  for ssh_config in `awk '
    $2 == "Host" {
      gsub("\\\\.", "\\\\.", $3);
      gsub("\\\\*", ".*", $3);
      host = $3;
      next;
    }
    $2 == "User" {
      $2 = "";
      sub( /^[[:space:]]*/, "" );
      printf "%s|%s\n", host, $0;
    }' $1`; do
    local host_regex=${ssh_config%|*}
    local host_user=${ssh_config#*|}
    if [[ "$2" =~ $host_regex ]]; then
      ssh_user=$host_user
      break
    fi
  done

  echo $ssh_user
}

get_ssh_user() {
  # Set default ssh_user as current user
  local ssh_user=$(whoami)

  # Search SSH User information in global configuration file
  ssh_user=$(search_ssh_user /etc/ssh/ssh_config $1)

  if [ -f ~/.ssh/config ]; then
    # Search SSH User information in user configuration file
    ssh_user=$(search_ssh_user ~/.ssh/config $1)
  fi

  echo $ssh_user
}

get_remote_info() {
  local command=$1

  # First get the current pane command pid to get the full command with arguments
  local cmd=$({ pgrep -flaP `tmux display-message -p "#{pane_pid}"` ; ps -o command -p `tmux display-message -p "#{pane_pid}"` ; } | xargs -I{} echo {} | grep ssh | sed -E 's/^[0-9]*[[:blank:]]*ssh //')
  local port=$(parse_ssh_port "$cmd")

  local cmd=$(echo $cmd|sed 's/\-p\s*'"$port"'//g')
  local user=$(echo $cmd | awk '{print $NF}'|cut -f1 -d@)
  local host=$(echo $cmd | awk '{print $NF}'|cut -f2 -d@)

  if [ $user == $host ]; then
    local user=$(get_ssh_user $host)
  fi

  case "$1" in
    "whoami")
      echo $user
      ;;
    "hostname")
      echo $host
      ;;
    "port")
      echo $port
      ;;
    *)
      echo "$user@$host:$port"
      ;;
  esac
}

get_info() {
  # If command is ssh get info from remote
  if $(ssh_connected); then
    echo $(get_remote_info $1)
  else
    echo $($1)
  fi
}

ssh_connected() {
  # Get current pane command
  local cmd=$(tmux display-message -p "#{pane_current_command}")

  [ $cmd = "ssh" ] || [ $cmd = "sshpass" ]
}

main() {
  hostname=$(get_info hostname)
  user=$(get_info whoami)

  # Only show port info if ssh session connected (no localhost) and option enabled
  if $(ssh_connected) && [[ $show_ssh_session_port == "true" ]] ; then
    port=$(get_info port)
    echo $user@$hostname:$port
  else
    echo $user@$hostname
  fi
}

main
