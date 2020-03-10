#!/usr/bin/env bash
set -e
set -u
set -o pipefail

echo 'Mounting S3 with s3fs'
sudo s3fs bedell-ramirez.music /var/music-backup -o allow_other -o use_path_request_style -o passwd_file=/home/kyle/.passwd-s3fs -o use_cache=/tmp

echo 'Syncing music to S3'
rsync -vau /home/kyle/Downloads/mps/ /var/music-backup --delete --temp-dir=/tmp --stats --progress --no-perms

echo 'Unmounting S3 with s3fs'
sudo umount /var/music-backup
