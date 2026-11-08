#!/usr/bin/env bash
# Runs media.sh once each time a camera card mounts (the camera on USB-C in Mass Storage mode, or its SD card in a
# reader). Started by the LaunchAgent com.dschau.media-on-mount (bootstrap.sh installs it), whose StartOnMount fires
# on every mount, so this exits quietly unless a mounted volume looks like a camera card (DCIM/ or PRIVATE/M4ROOT/)
# that hasn't been handled since it mounted. An empty card only gets a notification. A failed run isn't retried
# until the card is plugged in again. Skipped while media.sh is already running (by hand or from here).
#
# Output: ~/logs/media-on-mount.log (media.sh still writes its per-file ~/logs/media.log). A notification says when a
# run starts and how it ended. To turn it off: launchctl bootout gui/$(id -u)/com.dschau.media-on-mount
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$HOME/logs/media-on-mount.log"
SEEN="$HOME/logs/.media-on-mount.seen"   # one "<device> <attach time>" line per card mount already handled
mkdir -p "$(dirname "$LOG")"
touch "$SEEN"

notify() {
  osascript -e "display notification \"$1\" with title \"media\"" >/dev/null 2>&1 || true
}

# Identifies this mount, not just this card: the /dev node (e.g. /dev/disk4s1) is created when the disk attaches, so
# its change time is new on every plug-in even when the device name is reused.
mount_id() {
  local dev
  dev=$(df "$1" 2>/dev/null | awk 'NR == 2 { print $1 }')
  echo "$dev $(stat -f %c "$dev" 2>/dev/null || stat -c %Z "$dev" 2>/dev/null)"
}

# Let the volume finish mounting (and the camera's second slot appear) before looking at it.
sleep 5

for v in /Volumes/*; do
  [[ -d $v/DCIM || -d $v/PRIVATE/M4ROOT ]] || continue
  id=$(mount_id "$v")
  grep -qxF "$id" "$SEEN" && continue
  clips=0 pictures=0
  [[ -d $v/PRIVATE/M4ROOT/CLIP ]] && clips=$(find "$v/PRIVATE/M4ROOT/CLIP" -maxdepth 1 -iname '*.MP4' | wc -l | tr -d ' ')
  [[ -d $v/DCIM ]] && pictures=$(find "$v/DCIM" -type f ! -name '._*' ! -name .DS_Store | wc -l | tr -d ' ')
  name=$(basename "$v")
  if ((clips + pictures == 0)); then
    echo "$id" >>"$SEEN"
    notify "$name mounted: nothing on it to copy"
    continue
  fi

  if pgrep -f '(^|/)bash [^ ]*/scripts/media\.sh( |$)' >/dev/null; then
    notify "$name mounted, but media is already running. Run media again once it's done"
    continue
  fi
  echo "$id" >>"$SEEN"
  printf '\n──── %s: %s mounted, %s clip(s), %s DCIM file(s) ────\n' "$(date '+%F %T')" "$v" "$clips" "$pictures" >>"$LOG"
  notify "Copying $clips clip(s) and $pictures picture(s) from $name to the NAS"
  if CARD_DIR="$v" "$BASH" "$DIR/media.sh" </dev/null >>"$LOG" 2>&1; then
    notify "$name: done, photo-backup started"
  elif [[ -d $v ]]; then
    notify "$name: failed, see ~/logs/media-on-mount.log. Plug it in again (or run media) to retry"
  else
    notify "$name was ejected mid-copy; plug it back in to finish"
  fi
done

# Keep only the last 50 mounts.
tail -n 50 "$SEEN" >"$SEEN.tmp" && mv "$SEEN.tmp" "$SEEN"
