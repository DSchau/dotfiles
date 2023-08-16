#!/usr/bin/env bash
export VIDEO_DIR=/Volumes/Videos/PRIVATE/M4ROOT/CLIP
export PICTURES_DIR="/Volumes/CFExpress A/DCIM"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

IP_ADDRESS=$(ifconfig en0 | grep 'inet ' | cut -d"." -f1-3 | awk '{print $2}')

# Conditionally set the hostname
if [ "$IP_ADDRESS" = "10.193.1" ]; then
  HOSTNAME="10.193.1.250"
else
  HOSTNAME="ssh.dschau.dev"
fi

export SSH_CONNECTION_STRING="dschau@${HOSTNAME}"

export MEDIA_DIR="$SSH_CONNECTION_STRING:/media"
