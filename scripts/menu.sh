CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MENU_COMMANDS_FILE="$CURRENT_DIR/menu.sh"

source "$CURRENT_DIR/state.sh"

tmux set-environment -g MENU_COMMANDS_FILE "$MENU_COMMANDS_FILE"

set_theme_option() {
  local option=$1
  local value=$2

  tmux set-environment -g "@kanagawa-$option" "$value"
  write_option_to_state "@kanagawa-$option" "$value"
  source "$CURRENT_DIR/kanagawa.sh"
}

show_main_menu() {
  tmux display-menu -T "#[align=centre fg=green]Kanagawa flavor" -x R -y P \
    "" \
    "" \
    "Wave" w "run -b '#{MENU_COMMANDS_FILE} set_theme_option theme wave" \
    "Dragon" d "run -b '#{MENU_COMMANDS_FILE} set_theme_option theme dragon" \
    "Lotus" l "run -b '#{MENU_COMMANDS_FILE} set_theme_option theme lotus" \
    "" \
    "Close menu" q ""
}

if [ "$1" = "show_main_menu" ]; then
  show_main_menu
elif [ "$1" = "set_theme_option" ]; then
  set_theme_option "$2" "$3"
fi
