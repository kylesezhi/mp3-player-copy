#!/usr/bin/env bash
set -e
set -u
set -o pipefail

mps-dir ()
{
  echo '/home/kyle/Downloads/mps/'
}

mp3-player-dir ()
{
  echo '/media/kyle/SPORTPLUS/Music'
}

copy-mp3s ()
{
  # -v is verbose
  # -a is archive, aka, don't keep partially copied files on error
  # -u is update, aka, copy source files that are new
  # --delete is delete remote files that aren't in source
  rsync -vau $(mps-dir) $(mp3-player-dir) --delete --temp-dir=/tmp --stats --progress
}

remove-non-music-files ()
{
  echo 'Removing non mp3 files'
  rm "$(mp3-player-dir)/README.md"
}

copy-mp3s-to-player ()
{
  copy-mp3s
}

copy-mp3s-to-player
remove-non-music-files
