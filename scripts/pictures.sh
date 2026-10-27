#!/usr/bin/env bash
# Copy the card's DCIM originals to the NAS (/media/Pictures/Source), then turn the new ones into JPEGs
# (/media/Pictures/Optimized/<year>).
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DIR/env.sh"

OPTIMIZED_DIR="$HOME/Pictures/Optimized"
OUTPUT_DIR="$MEDIA_DIR/Pictures"
IMAGES='\.(arw|dng|jpe?g|hif|heic|tiff?|png)$'

new=$(mktemp -t pictures-new)
trap 'rm -f "$new" "$new".*' EXIT
mkdir -p "$OPTIMIZED_DIR"
cd "$CARD_DIR"   # rsync and exiftool see paths relative to here (DCIM/…), never write to the card

# 1. Originals first. rsync skips what the NAS already has and prints only the files it sent.
rsync -a --omit-dir-times --partial -e "$RSYNC_SSH" --exclude .DS_Store --exclude '._*' \
  --out-format='%n' DCIM "$OUTPUT_DIR/Source" | { grep -v '/$' || true; } >"$new.sent"
grep -iE "$IMAGES" "$new.sent" |
  # RAW+JPEG pairs would both become NAME.jpg: convert one of them, the camera's JPEG.
  awk '{ k = $0; sub(/\.[^.\/]*$/, "", k); e = tolower(substr($0, length(k) + 2))
         if (!(k in f) || e ~ /^jpe?g$/) f[k] = $0 } END { for (k in f) print f[k] }' >"$new" || true
echo "📸 $(wc -l <"$new.sent" | tr -d ' ') file(s) copied to the NAS, $(wc -l <"$new" | tr -d ' ') to convert"

# 2. Years for every new file from one exiftool process (DateTimeOriginal, else the file date), then sips in
#    parallel, straight into ~/Pictures/Optimized/<year>/.
convert_rc=0
if [[ -s $new ]]; then
  exiftool -q -q -m -T -d %Y -FilePath -DateTimeOriginal -FileModifyDate -@ "$new" |
    while IFS=$'\t' read -r file year modified; do
      [[ $year =~ ^[0-9]{4}$ ]] || year=$modified
      name=${file##*/}
      mkdir -p "$OPTIMIZED_DIR/$year"
      printf '%s\0%s\0' "$file" "$OPTIMIZED_DIR/$year/${name%.*}.jpg"
    done |
    xargs -0 -n 2 -P "$(sysctl -n hw.ncpu)" sh -c \
      'if sips -s format jpeg -s formatOptions 80 "$0" --out "$1" >/dev/null; then echo "  $1"
       else echo "  ❌ $0 (convert it by hand: it is on the NAS, so the next run skips it)" >&2; exit 1; fi' ||
    convert_rc=$?
  if ((convert_rc)); then
    echo "⚠️  some conversions failed (xargs exit $convert_rc); the originals are on the NAS" >&2
  fi
fi

# 3. Optimized JPEGs to the NAS (this also sends any left over from an earlier failed run).
rsync -a --partial -e "$RSYNC_SSH" --exclude .DS_Store --remove-source-files --out-format='%n' \
  "$OPTIMIZED_DIR/" "$OUTPUT_DIR/Optimized"

# 4. Only with REMOVE_FROM_CARD=1: delete the originals from the card (nothing left to send, so this only deletes).
if [[ $REMOVE_FROM_CARD == 1 ]]; then
  rsync -a --omit-dir-times -e "$RSYNC_SSH" --exclude .DS_Store --exclude '._*' --remove-source-files \
    DCIM "$OUTPUT_DIR/Source"
fi

echo "📸 Pictures sync complete."
exit "$convert_rc"
