# Backup

## Backup script
~/Documents/mp3-player-copy/backup-mp3.sh

## Mount
sudo s3fs bedell-ramirez.music /var/music-backup -o allow_other -o use_path_request_style -o passwd_file=/home/kyle/.passwd-s3fs -o use_cache=/tmp

## Unmount
sudo umount /var/music-backup
