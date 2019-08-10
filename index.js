const itunes = require('itunes-library-stream')
const userhome = require('userhome')
const path = require('path')
const fs = require('fs')
const execSync = require('child_process').execSync;
const allPass = require('ramda/src/allPass')
 
const location = path.resolve(userhome()
  , 'Music/iTunes/iTunes Music Library.xml'
)
let DEBUG = process.argv.length > 2 ? true : false

const musicPlayerPath = DEBUG ? '/Users/kyle/tmp' : '/Volumes/SPORTPLUS/Music'

if (!fs.existsSync(musicPlayerPath)) {
  console.error('ERROR Path does not exist:', musicPlayerPath)
  process.exit(-1)
}

let size = 0
const sizeLimitInGb = 14
const sizeLimitInBytes = sizeLimitInGb * 1000000000

const isGoodPlayCount = (track) => track['Play Count'] > 3
const isGoodFileType = (track) => !track.Kind.includes('Protected') && !track.Kind.includes('Purchased') && !track.Kind.includes('Internet audio')
const isGoodGenre = (track) => track.Genre !== 'Hip Hop/Rap'
const isGoodArtist = (track) => track.Artist !== 'Gavin DeGraw'
const isGoodSize = (track) => track.Size + size < sizeLimitInBytes

const isGoodMusicFile = allPass([isGoodPlayCount, isGoodFileType, isGoodGenre, isGoodArtist, isGoodSize])

const copyGoodMusicToPlayer = (track) => {
  try {
    if (track.Location === null) return
    const oldLocation = decodeURI(track.Location.substr(7))
    const filename = path.basename(oldLocation)
    const newLocation = path.join(musicPlayerPath, filename)
    const isFileAbsent = !fs.existsSync(newLocation)
    if (isGoodMusicFile(track) && isFileAbsent) {
      size = size + track.Size
      console.log('Copying [' + filename + ']')
      console.log('Total size:', size)
      if (!DEBUG) {
        fs.copyFileSync(oldLocation, newLocation)
      }
    }
  } catch (error) {
    console.error('ERROR Could not copy:', error, track)
  }
}

fs.createReadStream(location)
  .pipe(itunes.createTrackStream())
  .on('data', copyGoodMusicToPlayer)
  .on('end', () => runBashScripts)

const runBashScripts = () => {
  if (DEBUG) {
    console.log('Skipping bash scripts')
    return
  }

  const copyCode = execSync('./copy-mp3s-to-player.sh')
  if (copyCode < 0) {
    console.error('./copy-mp3s-to-player.sh')
    process.exit(copyCode)
  }

  const convertCode = execSync('./convert-m4as-to-mp3s.sh')
  if (convertCode < 0) {
    console.error('./convert-m4as-to-mp3s.sh')
    process.exit(convertCode)
  }
}
