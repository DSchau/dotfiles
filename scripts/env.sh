#!/usr/bin/env bash
# Shared settings for the camera ingest scripts (media.sh, videos.sh, pictures.sh).
# How it all fits together: https://github.com/DSchau/htpc-knowledge/blob/main/CAMERA.md

# The SD card. In a reader it mounts as /Volumes/Videos; over USB the camera's volume may have another name, so
# without that, use the one mounted volume that looks like a camera card (DCIM/ or PRIVATE/M4ROOT/).
if [[ -z ${CARD_DIR:-} ]]; then
  CARD_DIR=/Volumes/Videos
  if [[ ! -d $CARD_DIR ]]; then
    found=()
    for v in /Volumes/*; do [[ -d $v/DCIM || -d $v/PRIVATE/M4ROOT ]] && found+=("$v"); done
    ((${#found[@]} == 1)) && CARD_DIR=${found[0]}
    unset found v
  fi
fi
export CARD_DIR
export VIDEO_DIR="$CARD_DIR/PRIVATE/M4ROOT/CLIP"
export PICTURES_DIR="$CARD_DIR/DCIM"
export LOG_DIR="$HOME/logs"

HTPC_LAN_IP=192.168.0.250
LAN_PREFIX=192.168.0.

# The interface with the default route (Wi-Fi isn't always en0).
iface=$(route -n get default 2>/dev/null | awk '/interface:/ { print $2 }')
ip=$(ipconfig getifaddr "${iface:-en0}" 2>/dev/null || true)
if [[ $ip == "$HTPC_LAN_IP" ]]; then
  export ON_LAN=1 ON_HTPC=1 HTPC_HOST=localhost   # the card is in the Mac Studio itself: no SSH, /media is local
elif [[ $ip == "$LAN_PREFIX"* ]]; then
  export ON_LAN=1 HTPC_HOST=$HTPC_LAN_IP
else
  export ON_LAN=0 HTPC_HOST=ssh.dschau.dev   # Cloudflare tunnel: fine for ssh, far too slow for GBs of media
fi
unset iface ip

export SSH_CONNECTION_STRING="dschau@$HTPC_HOST"
if ((${ON_HTPC:-0})); then
  export MEDIA_DIR=${MEDIA_DIR:-/media}
else
  export MEDIA_DIR=${MEDIA_DIR:-"$SSH_CONNECTION_STRING:/media"}
fi

# Every rsync/ssh in a run shares one SSH connection.
export SSH_OPTS="-o ControlMaster=auto -o ControlPath=~/.ssh/cm-%C -o ControlPersist=60"
export RSYNC_SSH="ssh $SSH_OPTS"

# Files on the card are kept by default: the NAS is the only other copy until photo-backup has uploaded them.
# Reformat the card in the camera once it reports exit 0 (`media.sh status`). REMOVE_FROM_CARD=1 deletes them
# from the card as soon as they're on the NAS (the old behavior).
export REMOVE_FROM_CARD=${REMOVE_FROM_CARD:-0}

# DRY_RUN=1 (media.sh --dry-run): list what would be copied, converted and deleted; change nothing.
export DRY_RUN=${DRY_RUN:-0}

# show_plan <verb> <destination>: rsync --out-format='%n|%l' lines → "  <verb> <file> (<size>) → <dest>/<file>",
# then a total. Folders (names ending in /) are skipped.
show_plan() {
  awk -F'|' -v verb="$1" -v dest="$2" '
    function human(b,  u, i) { split("B KB MB GB TB", u, " "); i = 1; while (b >= 1024 && i < 5) { b /= 1024; i++ }
                               return sprintf(i == 1 ? "%d %s" : "%.1f %s", b, u[i]) }
    $1 != "" && $1 !~ /\/$/ { n++; total += $2; printf "  %s %s (%s) → %s/%s\n", verb, $1, human($2), dest, $1 }
    END { printf "  = %d file(s), %s\n", n, human(total) }'
}

# count: rsync --out-format='%n|%l' lines (from a --dry-run) → "<files> <bytes>", for progress.
count() {
  awk -F'|' '$1 != "" && $1 !~ /\/$/ { n++; b += $2 } END { print n + 0, b + 0 }'
}

# progress <label> <files> <bytes>: passes "name|bytes" lines through as names (for the log), and keeps one line on
# the terminal up to date: "   <label> 312/758 · 11.2 GB of 27.2 GB  DSC01234.ARW". The terminal is fd 3, which
# media.sh opens; without it this only passes the names through. rsync prints a name once the file is done.
progress() {
  if ! { true >&3; } 2>/dev/null; then cut -d'|' -f1; return; fi
  awk -F'|' -v label="$1" -v nt="$2" -v bt="$3" '
    function human(b,  u, i) { split("B KB MB GB TB", u, " "); i = 1; while (b >= 1024 && i < 5) { b /= 1024; i++ }
                               return sprintf(i == 1 ? "%d %s" : "%.1f %s", b, u[i]) }
    $1 == "" || $1 ~ /\/$/ { next }
    { n++; b += $2; print $1; fflush()
      name = $1; sub(/.*\//, "", name)
      line = sprintf("   %s %d/%d", label, n, nt); if (bt > 0) line = line " · " human(b) " of " human(bt)
      printf "\r\033[K%s  %s", line, name > "/dev/fd/3"; fflush("/dev/fd/3") }
    END { if (n) printf "\n" > "/dev/fd/3" }'
}
