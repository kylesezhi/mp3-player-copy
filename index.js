const itunes = require('itunes-library-stream')
const userhome = require('userhome')
const path = require('path')
const fs = require('fs')
const execSync = require('child_process').execSync
const allPass = require('ramda/src/allPass')
const checkSync = require('diskusage').checkSync
 
const location = path.resolve(userhome()
  , 'Music/iTunes/iTunes Music Library.xml'
)
let DEBUG = process.argv.length > 2 ? true : false

const musicPlayerPath = DEBUG ? '/Users/kyle/tmp' : '/Volumes/SPORTPLUS/Music'

if (!fs.existsSync(musicPlayerPath)) {
  console.error('ERROR Path does not exist:', musicPlayerPath)
  process.exit(-1)
}

const bytesToGb = (bytes) => bytes / gbToBytes(1)
const gbToBytes = (gb) => gb * 1000000000

let stats
try {
  stats = checkSync(musicPlayerPath)
} catch (error) {
  console.error('ERROR could not get stats for:', musicPlayerPath)
  process.exit(-1)
}

let size = 0
const sizeLimitInBytes = stats.free - gbToBytes(1)

const isGoodPlayCount = (track) => track['Play Count'] > 3
const isGoodFileType = (track) => !track.Kind.includes('Protected') && !track.Kind.includes('Purchased') && !track.Kind.includes('Internet audio')
const isGoodGenre = (track) => track.Genre !== 'Hip Hop/Rap' && track.Genre !== 'Interlude' && track.Genre !== 'Teaching'
const isGoodArtist = (track) => track.Artist !== 'Gavin DeGraw'
const isGoodSize = (track) => track.Size + size < sizeLimitInBytes
const isGoodDateModified = (track) => track['Date Modified'].getFullYear() > 2013

const isGoodMusicFile = allPass([isGoodPlayCount, isGoodFileType, isGoodGenre, isGoodArtist, isGoodSize, isGoodDateModified])

const copyGoodMusicToPlayer = (track) => {
  try {
    if (track.Location === null) return
    const oldLocation = decodeURIComponent(track.Location.substr(7))
    const filename = path.basename(oldLocation)
    const newLocation = path.join(musicPlayerPath, filename)
    const isFileAbsent = !fs.existsSync(newLocation)
    const modified = track['Date Modified']
    if (isGoodMusicFile(track) && isFileAbsent) {
      size = size + track.Size
      debugger
      console.log('Copying [' + filename + ']')
      console.log('Modified:', modified, modified.getFullYear())
      console.log('Total size:', bytesToGb(size), 'GB of', bytesToGb(sizeLimitInBytes), 'GB\n')
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
