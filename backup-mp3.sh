#!/usr/bin/env bash
set -e
set -u
set -o pipefail

sudo s3fs bedell-ramirez.music /var/music-backup -o allow_other -o use_path_request_style -o passwd_file=/home/kyle/.passwd-s3fs -o use_cache=/tmp

rsync -vau /home/kyle/Downloads/mps/ /var/music-backup --delete --temp-dir=/tmp --stats --progress

sudo umount /var/music-backup
