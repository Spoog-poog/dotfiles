#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
	selected=$1
else
	selected=$(find ~/ ~/Desktop/Projects ~/Desktop/Projects/MagicWand -mindepth 1 -maxdepth 1 -type d | fzf)
fi

echo $selected

if [[ -z $selected ]]; then
	exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [ ! "$tmux_running" ]; then
	tmux new-session -s "$selected_name" -c "$selected"
	exit 0
fi

if [ -z "$TMUX" ]; then
	tmux new-session -A -s "$selected_name" -c "$selected"
	exit 0
fi

if ! tmux has-session -t "$selected_name" 2>/dev/null; then
	tmux new-session -ds "$selected_name" -c "$selected"
fi

tmux switch-client -t "$selected_name"
