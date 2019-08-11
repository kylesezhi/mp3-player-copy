#!/usr/bin/env bash
set -e
set -u
set -o pipefail

m4a-files-dir ()
{
  echo '/Volumes/SPORTPLUS/Music/'
}

backup-m4a-files-dir ()
{
  echo "$(m4a-files-dir)m4a-backups"
}

make-backup-dir ()
{
  mkdir -p "$(backup-m4a-files-dir)"
}

m4a-file-list ()
{
  echo "$(m4a-files-dir)*.m4a"
}

delete-m4a-file ()
{
  local fileNameAndPath="${1:?}"

  rm "$fileNameAndPath"
}

move-m4a-file-to-backup-folder ()
{
  local fileNameAndPath="${1:?}"

  local filePath
  filePath=$(dirname "$fileNameAndPath")
  local fileName
  fileName=$(basename "$fileNameAndPath")
  local backupFileNameAndPath
  backupFileNameAndPath="$(backup-m4a-files-dir)/$fileName"

  mv "$fileNameAndPath" "$backupFileNameAndPath"
}

convert-and-delete-m4as ()
{
  for filename in $(m4a-file-list); do
    local newFileName
    newFileName="$(basename "$filename" .m4a).mp3"

    local newFilePath
    newFilePath="$(dirname "$filename")/$newFileName"

    ffmpeg "$newFilePath" -i "$filename" -codec:a libmp3lame -qscale:a 1 -y
    delete-m -file "$filename"
  done
}

convert-m4as-to-mp3s ()
{
  # make-backup-dir
  convert-and-delete-m4as
}

convert-m4as-to-mp3s
