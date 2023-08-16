#!/usr/bin/env bash

# share common environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/env.sh"

rsync "$VIDEO_DIR/." --progress --remove-source-files -rav --include "**/*.MP4" --exclude "*" "${MEDIA_DIR}/Videos/Photography"
