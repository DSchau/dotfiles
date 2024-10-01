#!/usr/bin/env bash
export VIDEO_DIR=/Volumes/Videos/PRIVATE/M4ROOT/CLIP
export PICTURES_DIR="/Volumes/Videos/DCIM"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

IP_ADDRESS=$(ifconfig en0 | grep 'inet ' | cut -d"." -f1-3 | awk '{print $2}')
IP_BASE="192.168.0"

# Conditionally set the hostname
if [ "$IP_ADDRESS" = "$IP_BASE" ]; then
  HOSTNAME="$IP_BASE.250"
else
  HOSTNAME="ssh.dschau.dev"
fi

export SSH_CONNECTION_STRING="dschau@${HOSTNAME}"

export MEDIA_DIR="$SSH_CONNECTION_STRING:/media"
