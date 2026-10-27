#!/usr/bin/env bash
# Copy camera clips and ~/Movies/Home videos (from drop.sh) to the NAS, /media/Videos/Home.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/env.sh"

dest="$MEDIA_DIR/Videos/Home"
card=()
[[ $REMOVE_FROM_CARD == 1 ]] && card=(--remove-source-files)

# The --exclude '*' also excludes subfolders, so these only copy the top level (CLIP/ is flat).
if [[ -d $VIDEO_DIR ]]; then
  rsync -a --partial -e "$RSYNC_SSH" --out-format='%n' ${card[@]+"${card[@]}"} \
    --include='*.MP4' --exclude='*' "$VIDEO_DIR/" "$dest"
fi

# These are converted copies (drop.sh), so they're removed from the Mac once they're on the NAS.
if [[ -d $HOME/Movies/Home ]]; then
  rsync -a --partial -e "$RSYNC_SSH" --out-format='%n' --remove-source-files \
    --include='*.mp4' --exclude='*' "$HOME/Movies/Home/" "$dest"
fi

echo "🎥 Video sync complete."
