#!/usr/bin/env bash

# Detect script directory (resolve symlinks) - portable version
if [ -n "${BASH_SOURCE:-}" ]; then
  SOURCE="${BASH_SOURCE[0]}"
else
  SOURCE="$0"
fi

# Resolve symlinks
while [ -L "$SOURCE" ]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  case "$SOURCE" in
    /*) ;;
    *) SOURCE="$SCRIPT_DIR/$SOURCE" ;;
  esac
done
SCRIPT_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
DPATH="${REALQUICK_HOME:-$SCRIPT_DIR}"

selected_date=$(zenity --calendar --title "Select a Date" --text "Choose a date" --date-format="%Y-%m-%d")

if [ -n "$selected_date" ]; then
    mkdir -p "$DPATH/inps"
    echo "$selected_date" > "$DPATH/inps/$1"
else
    echo "No date selected"
    exit 1
fi
