#!/usr/bin/env bash
set -e
set -u
set -o pipefail

BASE=/home/kyle

restic -r $BASE/Dropbox/Music/ backup $BASE/Downloads/mps/ --password-file $BASE/Documents/mp3-player-copy/.restic
