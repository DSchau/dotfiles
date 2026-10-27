#!/usr/bin/env bash
# Convert iPhone .mov files in ~/Movies/Drop to .mp4 in ~/Movies/Home (videos.sh copies them to the NAS).
# Remuxes when the streams fit in MP4 (no re-encode: fast and lossless). Otherwise re-encodes with the
# hardware HEVC encoder.
set -uo pipefail

INPUT_FOLDER="$HOME/Movies/Drop"
OUTPUT_FOLDER="$HOME/Movies/Home"
LOG_LEVEL="warning"

mkdir -p "$OUTPUT_FOLDER"

ff() { ffmpeg -y -nostdin -hide_banner -loglevel "$LOG_LEVEL" "$@"; }

# Keep the creation date and location (use_metadata_tags), and tag HEVC as hvc1 so Apple players open it.
remux() {  # remux <in> <out>
  local tag=()
  [[ $(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$1") == hevc ]] &&
    tag=(-tag:v hvc1)
  ff -i "$1" -c copy ${tag[@]+"${tag[@]}"} -map_metadata 0 -movflags +faststart+use_metadata_tags "$2"
}
encode() {  # encode <in> <out>
  ff -i "$1" -c:v hevc_videotoolbox -q:v 65 -tag:v hvc1 -c:a aac -b:a 192k \
    -map_metadata 0 -movflags +faststart+use_metadata_tags "$2"
}

total_files=$(find "$INPUT_FOLDER" -type f -iname "*.mov" | wc -l | tr -d ' ')
echo "Converting total of $total_files files"

current_file=0
find "$INPUT_FOLDER" -type f -iname "*.mov" -print0 | while IFS= read -r -d '' file; do
  filename=$(basename -- "$file")
  output_file="$OUTPUT_FOLDER/${filename%.*}.mp4"
  current_file=$((current_file + 1))
  progress="($current_file / $total_files)"

  if remux "$file" "$output_file"; then
    how=remuxed
  elif encode "$file" "$output_file"; then
    how=re-encoded
  else
    rm -f "$output_file"
    echo "❌ $progress Failed to convert $file"
    continue
  fi
  echo "✅ $progress Converted $file to $output_file ($how)"
  rm "$file"
done
