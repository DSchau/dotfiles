# share common environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/env.sh"

ssh "$SSH_CONNECTION_STRING" << 'EOF' > /Users/dustinschau/logs/htpc.log
  # Google Photos
  rclone sync /media/Pictures/Optimized/ google-photos:album/Photography --exclude .DS_Store --log-file /home/dschau/logs/rclone.log --config /home/dschau/.rclone.conf --log-level INFO

  # Cloudflare R2
  rclone sync /media/Pictures/Optimized/ pictures:pictures --exclude .DS_Store --log-file /home/dschau/logs/rclone.log --config /home/dschau/.rclone.conf --log-level INFO
EOF
