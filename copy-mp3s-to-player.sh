#!/usr/bin/env bash
set -e
set -u
set -o pipefail

mps-dir ()
{
  echo 'kyle@10.0.1.13:/home/kyle/Downloads/mps/'
}

mp3-player-dir ()
{
  echo '/Volumes/SPORTPLUS/Music'
}

copy-mp3s ()
{
  # -v is verbose
  # -a is archive, aka, don't keep partially copied files on error
  # -u is update, aka, copy source files that are new
  # --delete is delete remote files that aren't in source
  rsync -vau $(mps-dir) $(mp3-player-dir) --delete
}

copy-mp3s-to-player ()
{
  copy-mp3s
}

copy-mp3s-to-player
