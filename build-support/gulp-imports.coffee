through   = require 'through2'
gulp      = require 'gulp'
gutil     = require 'gulp-util'
Path      = require 'path'
_         = require 'lodash'

File      = gutil.File

module.exports = imports = (args={})->

  _.defaults args,
    src: []
    filename: 'imports.json'

  map = {}

  buffer = new File
    path: args.filename


  read = (file, encoding, done)->
    extname = (Path.extname file.relative).replace /\./g, ''

    if not map[extname] then map[extname] = []
    map[extname].push file.relative

    done()    

  write = (done)->
    buffer.contents = new Buffer JSON.stringify map
    this.push buffer
    done()


  return through.obj read, write