echo ':: Removing existing playlists'
rm -rf ~/Downloads/mps/Playlists/*

echo ':: Generating new playlists'
cd /home/kyle/Downloads/mps
for dir in */; do
  name=${dir%/} # remove trailing / from directories
  if [ "$name" != 'Playlists' ]; then
    echo ":: Creating playlist for $name"
    find /home/kyle/Downloads/mps/"$dir" -type f > /home/kyle/Downloads/mps/Playlists/"$name".m3u
  fi
done
