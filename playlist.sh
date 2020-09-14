echo ':: Removing existing playlists'
cd /home/kyle/Downloads/mps/Playlists
rm -rf .

echo ':: Generating new playlists'
cd /home/kyle/Downloads/mps
for dir in */; do
  name=${dir%/} # remove trailing / from directories
  if [ "$name" != 'Playlists' ]; then
    echo ":: Creating playlist for $name"
    find /home/kyle/Downloads/mps/"$dir" -type f > /home/kyle/Downloads/mps/Playlists/"$name".m3u
  fi
done
