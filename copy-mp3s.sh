#!/usr/bin/env bash
set -e
set -u
set -o pipefail

mount-dir ()
{
  echo $(mount | tail -1 | cut -d ' ' -f 1)
}

mps-dir ()
{
  echo '/home/kyle/Downloads/mps/'
}

mp3-player-dir ()
{
  echo '/media/kyle/BLADE'
}

mp3-player-music-dir ()
{
  echo '/media/kyle/BLADE/Music'
}

remove-this-character ()
{
  local character="${1:?}"

  echo "Removing character: ${character}"
  find $(mps-dir) -iname "*.mp3" | while read file
  do
    local destination
    destination=$(echo "$file" | sed "s/\$character//g")
    if [ "$file" != "${destination}"  ]
    then
      echo "[removing $character] $file"
      mv "$file" "${destination}"
    fi
  done
}

rename-files-with-illegal-characters ()
{
  echo 'Renaming files with illegal characters'
  remove-this-character '|'
  remove-this-character ':'
  remove-this-character '+'
  remove-this-character '/'
}

# https://help.ubuntu.com/community/Mount/USB
mount-usb-if-necessary ()
{
  # find mounted with: sudo fdisk -l
  if [ ! -d $(mp3-player-music-dir) ] # if the player directory does not exist
  then
    echo 'Mounting USB drive'
    sudo mkdir -p $(mp3-player-dir)
    sudo mount -t vfat $(mount-dir) $(mp3-player-dir) -o uid=1000,gid=1000,utf8,dmask=027,fmask=137
  fi
}

unmount-usb ()
{
  echo 'Unmounting USB drive'
  sudo umount $(mp3-player-dir)
}

copy-mp3s-to-player ()
{
  # -v is verbose
  # -a is archive, aka, don't keep partially copied files on error
  # BUT -rltgoDv is equivalent to -a, but doesn't try to set file ownership on the target
  # -u is update, aka, copy source files that are new
  # --delete is delete remote files that aren't in source
  rsync -rltgoDvu $(mps-dir) $(mp3-player-music-dir) --delete --temp-dir=/tmp --stats --progress 2>/dev/null
}

reminders ()
{
  echo 'Remember to run me with sudo!'
}

reminders
mount-usb-if-necessary
rename-files-with-illegal-characters
copy-mp3s-to-player
unmount-usb
