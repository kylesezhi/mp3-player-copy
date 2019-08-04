#!/usr/bin/env bash
set -e
set -u
set -o pipefail

for filename in /Volumes/SPORTPLUS/Kids/*.m4a; do
  ffmpeg "$filename.mp3" -i "$filename" -codec:a libmp3lame -qscale:a 1
  rm "$filename"
done
