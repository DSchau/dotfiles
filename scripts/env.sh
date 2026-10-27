#!/usr/bin/env bash
# Shared settings for the camera ingest scripts (media.sh, videos.sh, pictures.sh).
# How it all fits together: https://github.com/DSchau/htpc-knowledge/blob/main/CAMERA.md

export CARD_DIR=${CARD_DIR:-/Volumes/Videos}   # the SD card
export VIDEO_DIR="$CARD_DIR/PRIVATE/M4ROOT/CLIP"
export PICTURES_DIR="$CARD_DIR/DCIM"
export LOG_DIR="$HOME/logs"

HTPC_LAN_IP=192.168.0.250
LAN_PREFIX=192.168.0.

# The interface with the default route (Wi-Fi isn't always en0).
iface=$(route -n get default 2>/dev/null | awk '/interface:/ { print $2 }')
ip=$(ipconfig getifaddr "${iface:-en0}" 2>/dev/null || true)
if [[ $ip == "$LAN_PREFIX"* ]]; then
  export ON_LAN=1 HTPC_HOST=$HTPC_LAN_IP
else
  export ON_LAN=0 HTPC_HOST=ssh.dschau.dev   # Cloudflare tunnel: fine for ssh, far too slow for GBs of media
fi
unset iface ip

export SSH_CONNECTION_STRING="dschau@$HTPC_HOST"
export MEDIA_DIR=${MEDIA_DIR:-"$SSH_CONNECTION_STRING:/media"}

# Every rsync/ssh in a run shares one SSH connection.
export SSH_OPTS="-o ControlMaster=auto -o ControlPath=~/.ssh/cm-%C -o ControlPersist=60"
export RSYNC_SSH="ssh $SSH_OPTS"

# Files on the card are kept by default: the NAS is the only other copy until photo-backup has uploaded them.
# Reformat the card in the camera once it reports exit 0 (`media.sh status`). REMOVE_FROM_CARD=1 deletes them
# from the card as soon as they're on the NAS (the old behavior).
export REMOVE_FROM_CARD=${REMOVE_FROM_CARD:-0}
