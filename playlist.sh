cd /home/kyle/Downloads/mps
# find . -maxdepth 1 -mindepth 1 -type d -print0 | \
#  find -type f > home/kyle/Downloads/mps/Playlists/Oliver\ Dance.m3u
for dir in */; do
  name=${dir%/} # remove trailing / from directories
  find /home/kyle/Downloads/mps/"$dir" -type f > /home/kyle/Downloads/mps/Playlists/"$name".m3u
done
