#!/usr/bin/env bash

export VIDEO_DIR=/Volumes/Videos/PRIVATE/M4ROOT/CLIP
export PICTURES_DIR="/Volumes/CFExpress A/DCIM"

# just a hack to make it so that local shell scripts work
PATH="$PWD:$PATH"

IP_ADDRESS=$(ifconfig en0 | grep 'inet ' | cut -d"." -f1-3 | awk '{print $2}')

# Conditionally set the hostname
if [ "$IP_ADDRESS" = "10.193.1" ]; then
  HOSTNAME="10.193.1.250"
else
  HOSTNAME="ssh.dschau.dev"
fi

export MEDIA_DIR="dschau@${HOSTNAME}:/media"

add_date() {
  while IFS= read -r line; do
    printf '%s %s\n' "$(date)" "$line";
  done
}

if [ -d "$VIDEO_DIR" ]; then
  echo -e "🎥 \033[1mVideo\033[0m  Script, Running"
  sh -x "./videos.sh" | add_date >> "/Users/dustinschau/logs/media.log"
else
  echo -e "🎥 \033[1mVideo\033[0m directory not mounted, skipping."
fi

if [ -d "$PICTURES_DIR" ]; then
  echo -e "📸 \033[1mPictures\033[0  Script, Running"
  sh -x "./pictures.sh" | add_date >> "/Users/dustinschau/logs/media.log"
else
  echo -e "📸 \033[1mPictures\033[0m directory not mounted, skipping."
fi
