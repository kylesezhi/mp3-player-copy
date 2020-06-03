#!/usr/bin/env bash
set -e
set -u
set -o pipefail
# Reference:
# https://www.putorius.net/using-systemd-timers.html
# https://github.com/erikw/restic-systemd-automatic-backup

BASE=/home/kyle

restic -r $BASE/Dropbox/Music/ backup $BASE/Downloads/mps/ --password-file $BASE/Documents/mp3-player-copy/.restic
