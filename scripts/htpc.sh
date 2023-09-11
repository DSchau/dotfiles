# share common environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/env.sh"

echo "📝 Starting to copy all files on remote server: $SSH_CONNECTION_STRING"

RCLONE_ARGS="--stats-one-line --stats 2s --exclude .DS_Store --log-file /home/dschau/logs/rclone.log --config /home/dschau/.rclone.conf --log-level INFO" 

ssh -tt "$SSH_CONNECTION_STRING" << EOF > /Users/dustinschau/logs/htpc.log
  # Google Photos
  rclone sync /media/Pictures/Optimized/ google-photos:album/Photography \
    --transfers=2 \
    --checkers=2 \
    --tpslimit 2 \
    $RCLONE_ARGS

  # Raw Camera Files
  rclone sync /media/Pictures/Source/ raw:raw $RCLONE_ARGS

  # Videos / Home Movies (yes, actually)
  rclone sync /media/Videos/ videos:videos $RCLONE_ARGS

  # Cloudflare R2
  rclone sync /media/Pictures/Optimized/ pictures:pictures $RCLONE_ARGS
EOF

echo "✅ Successfully copied all files"
