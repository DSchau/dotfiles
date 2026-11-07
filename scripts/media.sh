#!/usr/bin/env bash
# Camera ingest: SD card + ~/Movies/Home → NAS, then start photo-backup on the Mac Studio (R2 + Google Photos).
# How it fits together: https://github.com/DSchau/htpc-knowledge/blob/main/CAMERA.md
#
#   media.sh            copy everything to the NAS, then start photo-backup
#   media.sh --dry-run  list what would be copied, converted and deleted (~/logs/media-dry-run.log); change nothing
#   media.sh status     the last photo-backup run (reformat the card once all 4 jobs end with exit 0)
set -uo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[[ ${1:-} == --dry-run || ${1:-} == dry-run ]] && export DRY_RUN=1
source "$DIR/env.sh"

LOG="$LOG_DIR/media.log"
REPORT="$LOG_DIR/media-dry-run.log"
mkdir -p "$LOG_DIR"

remote() {
  if ((${ON_HTPC:-0})); then bash -c "$*"; else ssh $SSH_OPTS "$SSH_CONNECTION_STRING" "$@"; fi
}

if [[ ${1:-} == status ]]; then
  remote 'grep "photo-backup:" ~/logs/rclone.log | tail -8; if pgrep -f "[/]usr/local/bin/photo-backup" >/dev/null; then echo "(still running)"; fi'
  exit
fi

if ((!ON_LAN)) && [[ ${ALLOW_REMOTE:-0} != 1 ]]; then
  echo -e "🛑 Not on the home network, so this would push GBs through the Cloudflare tunnel. Not running." >&2
  echo "   (ALLOW_REMOTE=1 media.sh to do it anyway)" >&2
  exit 1
fi

add_date() {
  while IFS= read -r line; do printf '%s %s\n' "$(date '+%F %T')" "$line"; done
}

# What this run will read and where it writes: the first thing to check when the camera mounts somewhere unexpected.
{
  ((DRY_RUN)) && echo "DRY RUN $(date '+%F %T'): nothing is copied, converted or deleted"
  if [[ -d $CARD_DIR ]]; then
    echo "Card:   $CARD_DIR ($(df -h "$CARD_DIR" | awk 'NR == 2 { print $3 " used" }'))"
    echo "        clips: $([[ -d $VIDEO_DIR ]] && find "$VIDEO_DIR" -maxdepth 1 -iname '*.MP4' | wc -l | tr -d ' ' || echo 'no PRIVATE/M4ROOT/CLIP')," \
         "DCIM files: $([[ -d $PICTURES_DIR ]] && find "$PICTURES_DIR" -type f ! -name '._*' ! -name .DS_Store | wc -l | tr -d ' ' || echo 'no DCIM')"
  else
    echo "Card:   none ($CARD_DIR isn't there; no single volume with DCIM/ or PRIVATE/M4ROOT/). Mounted: $(ls /Volumes | paste -sd, -)"
    echo "        A camera on USB must be in Mass Storage mode, not MTP/PC Remote, to mount. Or: CARD_DIR=/Volumes/X media.sh"
  fi
  echo "NAS:    $MEDIA_DIR (Videos/Home, Pictures/Source, Pictures/Optimized)"
  echo "Card files: $([[ $REMOVE_FROM_CARD == 1 ]] && echo 'deleted once on the NAS (REMOVE_FROM_CARD=1)' || echo 'kept')"
} | if ((DRY_RUN)); then tee "$REPORT"; else cat; fi | tee >(add_date >>"$LOG")

# fd 3 is the terminal, for the scripts' progress lines (progress in env.sh); everything else goes to the log
exec 3>&1

failed=0
run() {  # run <emoji> <name> <script>: trace and output go to the log, a summary to the terminal
  echo -e "$1 \033[1m$2\033[0m running (tail -f $LOG)"
  echo "==== $3$( ((DRY_RUN)) && echo ' (dry run)')" | add_date >>"$LOG"
  if ((DRY_RUN)); then
    # No trace: the plan is the output. It goes to the report and the log; totals to the terminal.
    if "$BASH" "$DIR/$3" 2>&1 | tee -a "$REPORT" | tee >(add_date >>"$LOG") |
         { grep -E '^(🎥|📸|  =|  ❌|⚠️)' || true; }; then
      echo -e "   ✅ done"
    else
      echo -e "   ❌ \033[1m$3\033[0m failed, see $REPORT" >&2
      failed=1
    fi
  elif "$BASH" -x "$DIR/$3" 2>&1 | add_date >>"$LOG"; then
    echo -e "   ✅ done"
  else
    echo -e "   ❌ \033[1m$3\033[0m failed, see $LOG" >&2
    failed=1
  fi
}

if [[ -d $VIDEO_DIR || -d $HOME/Movies/Home ]]; then
  run 🎥 Videos videos.sh
else
  echo -e "🎥 \033[1mVideos\033[0m: nothing mounted, skipping."
fi

if [[ -d $PICTURES_DIR ]]; then
  run 📸 Pictures pictures.sh
else
  echo -e "📸 \033[1mPictures\033[0m: card not mounted, skipping."
fi

if ((failed)); then
  echo -e "🛑 Not starting the backup to R2 / Google Photos. Fix the error and run media.sh again." >&2
  exit 1
fi

if ((DRY_RUN)); then
  echo "🍿 Then photo-backup would start (R2 + Google Photos). To see what it would upload now: photo-backup --dry-run" |
    tee -a "$REPORT"
  echo "📝 Full plan: $REPORT"
  exit 0
fi

# photo-backup has the safety checks (flock, empty-source check, --max-delete, bandwidth limit) and the right R2
# paths. Detached, so this returns right away; it logs to ~/logs/rclone.log on the Studio. Homebrew's bash and PATH,
# as in its launchd job: an SSH session has no flock, and macOS can block /bin/bash from the NAS.
if remote 'PATH=/opt/homebrew/bin:$PATH nohup /opt/homebrew/bin/bash /usr/local/bin/photo-backup </dev/null >/dev/null 2>&1 &'; then
  echo -e "🍿 \033[1mphoto-backup\033[0m started on the Studio. Check it with: media.sh status"
else
  echo -e "❌ Couldn't start photo-backup on the Studio. It still runs at 04:00." >&2
  exit 1
fi
if [[ $REMOVE_FROM_CARD != 1 && -d $CARD_DIR/DCIM ]]; then
  echo "💾 Everything is still on the card. Reformat it in the camera once photo-backup ends with exit 0."
fi
