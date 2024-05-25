render() {
  tmux display-menu -T "#[align=centre fg=green]Options" -x R -y P \
    "" \
    "" \
    "" \
    "<-- Back" b "run -b 'source #{@kanagawa-root}/menu_items/main.sh" \
    "Close menu" q ""
}

render
