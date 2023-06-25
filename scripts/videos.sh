#!/usr/bin/env bash

rsync "$VIDEO_DIR/." --progress -rav --include "**/*.MP4" --exclude "*" "${MEDIA_DIR}/Videos/Photography"
