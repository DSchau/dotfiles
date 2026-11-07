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
((DRY_RUN)) || mkdir -p "$OPTIMIZED_DIR"
cd "$CARD_DIR"   # rsync and exiftool see paths relative to here (DCIM/…), never write to the card

# Dry run: rsync and exiftool only read; nothing is copied, converted or deleted. Each step prints its plan.

# 1. Originals first. rsync skips what the NAS already has and prints only the files it sent.
originals() {  # originals [--dry-run]
  rsync -a --omit-dir-times --partial -e "$RSYNC_SSH" "$@" --exclude .DS_Store --exclude '._*' \
    --out-format='%n|%l' DCIM "$OUTPUT_DIR/Source"
}
if ((DRY_RUN)); then
  echo "📸 Originals in $CARD_DIR/DCIM:"
  originals --dry-run | { grep -v '/|' || true; } >"$new.plan"
  show_plan copy "$OUTPUT_DIR/Source" <"$new.plan"
else
  # A --dry-run first, for the totals in the progress line (it only lists, so it's quick)
  read -r files bytes < <(originals --dry-run | count)
  originals | { grep -v '/|' || true; } | tee "$new.plan" | progress "Copying originals" "$files" "$bytes"
fi
cut -d'|' -f1 "$new.plan" >"$new.sent"
grep -iE "$IMAGES" "$new.sent" |
  # RAW+JPEG pairs would both become NAME.jpg: convert one of them, the camera's JPEG.
  awk '{ k = $0; sub(/\.[^.\/]*$/, "", k); e = tolower(substr($0, length(k) + 2))
         if (!(k in f) || e ~ /^jpe?g$/) f[k] = $0 } END { for (k in f) print f[k] }' >"$new" || true
echo "📸 $(wc -l <"$new.sent" | tr -d ' ') file(s) $( ((DRY_RUN)) && echo 'would be' ) copied to the NAS, $(wc -l <"$new" | tr -d ' ') to convert"
if ((DRY_RUN)); then  # what's copied but not converted, and why (to tune IMAGES and the RAW+JPEG rule)
  sort "$new" >"$new.converted"
  sort "$new.sent" | comm -23 - "$new.converted" | while IFS= read -r f; do
    if grep -qiE "$IMAGES" <<<"$f"; then
      echo "  not converted: $f (its RAW+JPEG partner is converted instead)"
    else
      echo "  not converted: $f (not an image type: IMAGES in pictures.sh)"
    fi
  done
fi

# 2. Years for every new file from one exiftool process (DateTimeOriginal, else the file date), then sips in
#    parallel, straight into ~/Pictures/Optimized/<year>/.
convert_rc=0
if [[ -s $new ]] && ((DRY_RUN)); then
  echo "📸 Conversions (sips, JPEG quality 80), via $OPTIMIZED_DIR:"
  exiftool -q -q -m -T -d %Y -FilePath -DateTimeOriginal -FileModifyDate -@ "$new" |
    while IFS=$'\t' read -r file year modified; do
      how="DateTimeOriginal"
      [[ $year =~ ^[0-9]{4}$ ]] || { year=$modified; how="no DateTimeOriginal, file date"; }
      name=${file##*/}
      echo "  convert ${file#"$CARD_DIR"/} → $OUTPUT_DIR/Optimized/$year/${name%.*}.jpg (year from $how)"
    done
elif [[ -s $new ]]; then
  exiftool -q -q -m -T -d %Y -FilePath -DateTimeOriginal -FileModifyDate -@ "$new" |
    while IFS=$'\t' read -r file year modified; do
      [[ $year =~ ^[0-9]{4}$ ]] || year=$modified
      name=${file##*/}
      mkdir -p "$OPTIMIZED_DIR/$year"
      printf '%s\0%s\0' "$file" "$OPTIMIZED_DIR/$year/${name%.*}.jpg"
    done |
    xargs -0 -n 2 -P "$(sysctl -n hw.ncpu)" sh -c \
      'if sips -s format jpeg -s formatOptions 80 "$0" --out "$1" >/dev/null; then echo "$1"
       else echo "  ❌ $0 (convert it by hand: it is on the NAS, so the next run skips it)" >&2; exit 1; fi' |
    progress Converting "$(wc -l <"$new" | tr -d ' ')" 0 ||
    convert_rc=$?
  if ((convert_rc)); then
    echo "⚠️  some conversions failed (xargs exit $convert_rc); the originals are on the NAS" >&2
  fi
fi

# 3. Optimized JPEGs to the NAS (this also sends any left over from an earlier failed run).
optimized() {  # optimized [rsync args]
  rsync -a --partial -e "$RSYNC_SSH" --exclude .DS_Store --out-format='%n|%l' "$@" \
    "$OPTIMIZED_DIR/" "$OUTPUT_DIR/Optimized"
}
if ((DRY_RUN)); then
  if [[ -d $OPTIMIZED_DIR ]]; then
    echo "📸 Left over in $OPTIMIZED_DIR from an earlier run (sent along with the new JPEGs):"
    optimized --dry-run | show_plan copy "$OUTPUT_DIR/Optimized"
  fi
else
  read -r files bytes < <(optimized --dry-run | count)
  optimized --remove-source-files | progress "Copying JPEGs" "$files" "$bytes"
fi

# 4. Only with REMOVE_FROM_CARD=1: delete the originals from the card (nothing left to send, so this only deletes).
if [[ $REMOVE_FROM_CARD == 1 ]] && ((DRY_RUN)); then
  echo "📸 REMOVE_FROM_CARD=1: every DCIM file that's on the NAS would then be deleted from the card"
elif [[ $REMOVE_FROM_CARD == 1 ]]; then
  rsync -a --omit-dir-times -e "$RSYNC_SSH" --exclude .DS_Store --exclude '._*' --remove-source-files \
    DCIM "$OUTPUT_DIR/Source"
fi

if ((DRY_RUN)); then echo "📸 Pictures: dry run, nothing copied, converted or deleted."; else echo "📸 Pictures sync complete."; fi
exit "$convert_rc"
