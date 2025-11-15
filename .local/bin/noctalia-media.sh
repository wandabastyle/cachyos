#!/usr/bin/env bash

MAX=32           # width of the button text
SPEED=3          # characters per second (tweak this)
EMPTY_MARKER="__NO_TRACK__"   # what we'll use for textCollapse

# Get metadata from playerctl
full=$(playerctl metadata --format '{{artist}} – {{title}} ({{album}})' 2>/dev/null)

# Nothing playing / no metadata: output marker so the widget can collapse
if [ -z "$full" ]; then
  printf '%s\n' "$EMPTY_MARKER"
  exit 0
fi

len=${#full}

# No need to scroll if it fits
if (( len <= MAX )); then
  printf '%s\n' "$full"
  exit 0
fi

# Repeat text so we can wrap-around smoothly
scroll="$full • $full"

# Time in deciseconds (0.1s resolution)
t_ds=$(( $(date +%s%N) / 100000000 ))

# offset = time * SPEED (chars/s), all integer math
step=$(( (t_ds * SPEED / 10) % len ))

# Output the current window
printf '%s\n' "${scroll:step:MAX}"

