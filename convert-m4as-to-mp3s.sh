#!/usr/bin/env bash
set -e
set -u
set -o pipefail

m4a-files-dir ()
{
  echo '/Volumes/SPORTPLUS/Kids/'
}

backup-m4a-files-dir ()
{
  echo "$(m4a-files-dir)/m4a-backups"
}

make-backup-dir ()
{
  mkdir "$(backup-m4a-files-dir)"
}

m4a-file-list ()
{
  echo "$(m4a-files-dir)*.m4a"
}

move-m4a-file-to-backup-folder ()
{
  local fileNameAndPath="${1:?}"

  local filePath
  filePath=$(dirname "$fileNameAndPath")
  local fileName
  fileName=$(basename "$fileNameAndPath")
  local backupFileNameAndPath
  backupFileNameAndPath="$filePath/m4a-backup/$fileName"

  mv '$fileNameAndPath' '$backupFileNameAndPath'
}

convert-m4as-to-mp3s ()
{
  make-backup-dir
  for filename in $(m4a-file-list); do
    local newFileName
    newFileName="$(basename "$filename" .m4a).mp3"

    ffmpeg "$newFileName" -i "$filename" -codec:a libmp3lame -qscale:a 1
    move-m4a-file-to-backup-folder "$filename"
  done
}

convert-m4as-to-mp3s
