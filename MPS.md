# mps-youtube Tips

## Encoding to mp3 suddenly stopped?
> set encoder 1

## Download with metadata
ytdl -a [url|id]

## Manually encode webm to mp3
ffmpeg -i IN -codec:a libmp3lame -b:a 256k OUT.EXT
for f in *.webm; do ffmpeg -i "$f" -codec:a libmp3lame -b:a 256k "${f%.webm}.mp3"; done

## Youtube to MP3 (NO metadata!)
youtube-dl --extract-audio --audio-format mp3 --audio-quality 256K --prefer-ffmpeg --ffmpeg-location /usr/bin/ffmpeg <video URL>

## Illegal characters
The Sandisk is vfat, which I think means that these characters in filenames cause rsync errors:
: ? |

## Upgrade
sudo -H pip3 install --upgrade youtube-dl pafy
sudo -H pip3 install --upgrade youtube-dl
sudo -H pip3 install --upgrade mps-youtube

If installed with `apt install mps-youtube`, pip3 upgrade doesn't seem to work. So don't do that! :)

## Data API error
Make new API key, do:
rm ~/.config/mps-youtube/cache_py*
mpsyt set api_key [new key]
