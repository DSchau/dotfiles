#!/usr/bin/env bash
# Runs media.sh when a camera card mounts (the camera on USB-C in Mass Storage mode, or its SD card in a reader).
# Started by the LaunchAgent com.dschau.media-on-mount (bootstrap.sh installs it), whose StartOnMount fires on every
# mount, so this exits quietly unless a mounted volume looks like a camera card (DCIM/ or PRIVATE/M4ROOT/) and has
# files on it. Card files are deleted once they're on the NAS (REMOVE_FROM_CARD=1), so a card that's already been
# ingested has nothing left and isn't run again when something else mounts.
#
# Output: ~/logs/media-on-mount.log (media.sh still writes its per-file ~/logs/media.log). A notification says when a
# run starts and how it ended. To turn it off: launchctl bootout gui/$(id -u)/com.dschau.media-on-mount
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$HOME/logs/media-on-mount.log"
mkdir -p "$(dirname "$LOG")"

notify() {
  osascript -e "display notification \"$1\" with title \"media\"" >/dev/null 2>&1 || true
}

# Let the volume finish mounting (and the camera's second slot appear) before looking at it.
sleep 5

for v in /Volumes/*; do
  [[ -d $v/DCIM || -d $v/PRIVATE/M4ROOT ]] || continue
  clips=0 pictures=0
  [[ -d $v/PRIVATE/M4ROOT/CLIP ]] && clips=$(find "$v/PRIVATE/M4ROOT/CLIP" -maxdepth 1 -iname '*.MP4' | wc -l | tr -d ' ')
  [[ -d $v/DCIM ]] && pictures=$(find "$v/DCIM" -type f ! -name '._*' ! -name .DS_Store | wc -l | tr -d ' ')
  ((clips + pictures)) || continue

  name=$(basename "$v")
  printf '\n──── %s: %s mounted, %s clip(s), %s DCIM file(s) ────\n' "$(date '+%F %T')" "$v" "$clips" "$pictures" >>"$LOG"
  notify "Copying $clips clip(s) and $pictures picture(s) from $name to the NAS"
  if CARD_DIR="$v" "$BASH" "$DIR/media.sh" </dev/null >>"$LOG" 2>&1; then
    notify "$name: done, photo-backup started"
  elif [[ -d $v ]]; then
    notify "$name: failed, see ~/logs/media-on-mount.log"
  else
    notify "$name was ejected mid-copy; plug it back in to finish"
  fi
done
