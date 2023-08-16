#!/usr/bin/env bash

# share common environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/env.sh"

add_date() {
  while IFS= read -r line; do
    printf '%s %s\n' "$(date)" "$line";
  done
}

if [ -d "$VIDEO_DIR" ]; then
  echo -e "🎥 \033[1mVideo\033[0m  Script, Running"
  sh -x "$DIR/videos.sh" | add_date >> "/Users/dustinschau/logs/media.log"
else
  echo -e "🎥 \033[1mVideo\033[0m directory not mounted, skipping."
fi

if [ -d "$PICTURES_DIR" ]; then
  echo -e "📸 \033[1mPictures\033[0  Script, Running"
  sh -x "$DIR/pictures.sh" | add_date >> "/Users/dustinschau/logs/media.log"
else
  echo -e "📸 \033[1mPictures\033[0m directory not mounted, skipping."
fi

echo -e "🍿 \033[1mHTPC\033[0m upload, starting now."
sh -x "$DIR/htpc.sh"
echo -e "✅ \033[1mHTPC\033[0m upload, finished."
