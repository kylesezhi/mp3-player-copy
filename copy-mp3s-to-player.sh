#!/usr/bin/env bash
set -e
set -u
set -o pipefail

mps-dir ()
{
  echo /Users/kyle/Downloads/mps/
}

mp3-player-dir ()
{
  echo '/Volumes/SPORTPLUS/Music'
}

copy-mp3s ()
{
  # -v is verbose
  # -a is archive, aka, don't keep partially copied files on error
  rsync -va $(mps-dir) $(mp3-player-dir)
}

remove-non-music-files ()
{
  rm "$(mp3-player-dir)/.DS_Store"
}

copy-mp3s-to-player ()
{
  copy-mp3s
  remove-non-music-files
}

copy-mp3s-to-player
