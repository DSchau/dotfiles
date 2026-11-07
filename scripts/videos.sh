#!/usr/bin/env bash
# Copy camera clips and ~/Movies/Home videos (from drop.sh) to the NAS, /media/Videos/Home.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/env.sh"

dest="$MEDIA_DIR/Videos/Home"
card=()
[[ $REMOVE_FROM_CARD == 1 ]] && card=(--remove-source-files)

# Dry run: rsync lists what it would send (with sizes) and copies nothing; show_plan makes that readable.
send() {  # send <rsync args...>
  if ((DRY_RUN)); then
    rsync -a --dry-run -e "$RSYNC_SSH" --out-format='%n|%l' "$@" | show_plan copy "$dest"
  else
    rsync -a --partial -e "$RSYNC_SSH" --out-format='%n' "$@"
  fi
}

# The --exclude '*' also excludes subfolders, so these only copy the top level (CLIP/ is flat).
if [[ -d $VIDEO_DIR ]]; then
  ((DRY_RUN)) && echo "🎥 Camera clips in $VIDEO_DIR$([[ $REMOVE_FROM_CARD == 1 ]] && echo ', then deleted from the card'):"
  send ${card[@]+"${card[@]}"} --include='*.MP4' --exclude='*' "$VIDEO_DIR/" "$dest"
fi

# These are converted copies (drop.sh), so they're removed from the Mac once they're on the NAS.
if [[ -d $HOME/Movies/Home ]]; then
  ((DRY_RUN)) && echo "🎥 ~/Movies/Home (from drop.sh), then deleted from the Mac:"
  send --remove-source-files --include='*.mp4' --exclude='*' "$HOME/Movies/Home/" "$dest"
fi

if ((DRY_RUN)); then echo "🎥 Videos: dry run, nothing copied."; else echo "🎥 Video sync complete."; fi
