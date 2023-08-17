#!/usr/bin/env bash

# share common environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/env.sh"

# camera directory
rsync "$VIDEO_DIR/." --progress --remove-source-files -rav --include "**/*.MP4" --exclude "*" "${MEDIA_DIR}/Videos/Home"

# back up select iPhone Videos
rsync "$HOME/Movies/Home/" --progress --remove-source-files -rav --include "**/*.mp4" --exclude "*" "${MEDIA_DIR}/Videos/Home"
