#!/usr/bin/env bash
set -e
set -u
set -o pipefail

rsync -vau /home/kyle/Downloads/mps/ /var/music-backup --delete --temp-dir=/tmp --stats --progress
