#!/usr/bin/env bash

rsync "$VIDEO_DIR/." --progress --remove-source-files -rav --include "**/*.MP4" --exclude "*" "${MEDIA_DIR}/Videos/Photography"
