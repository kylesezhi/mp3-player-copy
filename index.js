var itunes = require('itunes-library-stream')
var userhome = require('userhome')
var path = require('path')
var fs = require('fs')
 
var location = path.resolve(userhome()
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
