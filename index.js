const itunes = require('itunes-library-stream')
const userhome = require('userhome')
const path = require('path')
const fs = require('fs')
const execSync = require('child_process').execSync;
const allPass = require('ramda/src/allPass')
 
const location = path.resolve(userhome()
  , 'Music/iTunes/iTunes Music Library.xml'
)

// const musicPlayerPath = '/Volumes/SPORTPLUS/Music'
const musicPlayerPath = '/Users/kyle/tmp'

if (!fs.existsSync(musicPlayerPath)) {
  process.exit(-1)
}

const isGoodPlayCount = (track) => track['Play Count'] > 60
const isGoodFileType = (track) => track.Kind !== 'Protected AAC audio file'
const isGoodGenre = (track) => track.Genre !== 'Hip Hop/Rap'
const isGoodArtist = (track) => track.Artist !== 'Gavin DeGraw'

const isGoodMusicFile = allPass([isGoodPlayCount, isGoodFileType, isGoodGenre, isGoodArtist])

const copyGoodMusicToPlayer = (track) => {
  try {
    const oldLocation = decodeURI(track.Location.substr(7))
    const filename = path.basename(oldLocation)
    const newLocation = path.join(musicPlayerPath, filename)
    const isFileAbsent = !fs.existsSync(newLocation)
    if (isGoodMusicFile(track) && isFileAbsent) {
      console.log('Copying', filename)
      // fs.copyFileSync(oldLocation, newLocation) // TODO tmp
    }
  } catch (error) {
    console.error('Could not copy', error, track)
  }
}

fs.createReadStream(location)
  .pipe(itunes.createTrackStream())
  .on('data', copyGoodMusicToPlayer)
  .on('finish', () => console.log('Finished !!! :D'))

// const copyCode = execSync('./copy-mp3s-to-player.sh')
// if (copyCode < 0) {
//   console.error('./copy-mp3s-to-player.sh')
//   process.exit(copyCode)
// }

// const convertCode = execSync('./convert-m4as-to-mp3s.sh')
// if (convertCode < 0) {
//   console.error('./convert-m4as-to-mp3s.sh')
//   process.exit(convertCode)
// }
