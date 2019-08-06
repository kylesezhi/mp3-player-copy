const itunes = require('itunes-library-stream')
const userhome = require('userhome')
const path = require('path')
const fs = require('fs')
const execSync = require('child_process').execSync;
 
const location = path.resolve(userhome()
  , 'Music/iTunes/iTunes Music Library.xml'
)

const isGoodMusicFile = (track) => {
  const count = track['Play Count']
  const kind = track.Kind
  return count > 60 && kind !== 'Protected AAC audio file'
}

const musicPlayerPath = '/Volumes/SPORTPLUS/Music'

if (!fs.existsSync(musicPlayerPath)) {
  process.exit(-1)
}

fs.createReadStream(location)
  .pipe(itunes.createTrackStream())
  .on('data', function(track) {
    if (isGoodMusicFile(track)) {
      const filename = path.basename(location)
      const oldLocation = decodeURI(track.Location.substr(7))
      const newLocation = path.join(musicPlayerPath, filename)
      console.log('Copying', filename)
      fs.copyFileSync(oldLocation, newLocation)
     }
  })

const copyCode = execSync('./copy-mp3s-to-player.sh')
if (copyCode < 0) {
  process.exit(-1)
}

const convertCode = execSync('./convert-m4as-to-mp3s.sh')
if (convertCode < 0) {
  process.exit(-1)
}
