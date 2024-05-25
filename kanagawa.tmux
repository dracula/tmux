#!/usr/bin/env bash

# source and run kanagawa theme

current_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR=$current_dir
tmux set-environment -g "@kanagawa-root" "$ROOT_DIR"

$current_dir/scripts/kanagawa.sh
