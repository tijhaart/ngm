glob  = require 'glob'
gulp  = require 'gulp'
gutil = require 'gulp-util'
fs    = require 'fs'
Path = path  = require 'path' # @todo path -> Path
_str  = require 'underscore.string'
es    = require 'event-stream'
_     = require 'lodash'
async = require 'async'
es    = require 'event-stream'

lazypipe    = require 'lazypipe'
streamqueue = require 'streamqueue'
multistream = require 'multistream-merge'

clean   = require 'gulp-clean'
coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
wrap    = require 'gulp-wrap'
jade    = require 'gulp-jade'
ngtpl   = require 'gulp-angular-templatecache'
debug   = require 'gulp-debug'
sweet   = require 'gulp-sweetjs'
pretty  = require 'gulp-js-prettify'
gulpif  = require 'gulp-if'
sass    = require 'gulp-sass'
watch   = require 'gulp-watch'
plumber = require 'gulp-plumber'

ngmodules = require './build-support/ngm-tasks'
ngm       = require './build-support/ngm'
imports   = require './build-support/gulp-imports'

DEST_ROOT = '.tmp/public/'
dest = (dirpath)-> path.normalize "#{DEST_ROOT}/#{dirpath}"
client = (dirpath) -> path.normalize "./client#{dirpath}" 

process.env.NODE_ENV = 'develop'
env = process.env.NODE_ENV

isDev = -> env == 'develop'

watchFiles = isDev()

###*
 * @todo fix assets
 * @todo setup develop with livereload of server 

 * @todo uglify and put in single app.min.js based on NODE_ENV [development | production]
 * @todo uglify and merge vendors into vendor.min.js
 * @todo scaffold unit tests and e2e tests
 * @todo fix/disable hygenic fail for sweetjs in modules
 * @todo checkout https://github.com/tgriesser/bookshelf/
 * 
 * @done make seperate client and server folder
 * @done [sass] figure out how to use key val pairs object (http://codepen.io/tijhaart/pen/JBxng?editors=010) -> node-sass uses 3.2 :(
 * @done set up base, config for scss theming
 * @done add vendor scripts
###

gulp.task 'default', ->

gulp.task 'imports', ->
  sources = [ 
    # vendor: should be vendor.min.css
    # for production it should find only one css file (e.g. ng-modules.min.css)
    dest('/ng-modules/css/*.css'),
    dest('/css/theme.css')
    dest('/vendor/vendor.js'),
    dest('/js/*.js'),
    dest('/ng-modules/js/*.js')
    dest('/ng-modules/ngm-main.js')
  ]

  gulp.src sources, read: false, base: DEST_ROOT
    .pipe imports filename: 'imports.json'
    .pipe pretty wrap_line_length: 10
    .pipe gulp.dest DEST_ROOT

gulp.task 'run-server', ->
  app = require('./app/src')()


gulp.task 'ngm:compile', ngmodules.$tasks['compile'], ->

gulp.task 'ngm:main', ['ngm:compile'], ->
  gulp.src (client '/src/ng-modules/ngm-main.coffee')
    # .pipe watch()
    .pipe coffee()
    .pipe gulp.dest dest('/ng-modules/')

# @todo use batchstream to collect multiple changes
gulp.task 'livereload', ->
  gulp.watch (dest '/**/*'), ()->
    # call lr with changes

gulp.task 'assets:css', ->
  gulp.src [ client '/src/assets/css/theme/*.scss', client '/src/assets/css/base/*.scss' ]
    .pipe sass()
    .pipe gulp.dest dest('/css')

gulp.task 'vendor:js', ->

  task = ->    
    bower = require './bower.json'
    # this will maintain the order set in in bower.json
    sources = _.map bower.dependencies, (vendor, index)->
      # will also include local vendor scripts b/c bower installs and copies to vendor dir
      return client "/src/assets/vendor/#{index}/index.js" 
    gulp.src sources
      .pipe concat 'vendor.js'
      .pipe gulp.dest dest '/vendor'

  task()

gulp.task 'assets:js', ->
  base    = (path) -> client '/src/assets' + path
  js      = base '/js/*.js'
  _coffee = base '/js/*.coffee'

  task = ->
    streamqueue( objectMode: true,
      (gulp.src js),      
      (gulp.src _coffee
        .pipe coffee())
    )
      .pipe concat 'scripts.js'
      .pipe gulp.dest dest '/js/'

  stream = task()

  if watchFiles
    gutil.log 'watching: ', js, _coffee
    gulp.watch [js, _coffee], -> 
      gutil.log arguments 
      task()

  return stream


gulp.task 'assets:all', ['assets:css' 'vendor:js', 'assets:js']

gulp.task 'clean', ->
  gulp.src '.tmp'
    .pipe clean read: false

# gulp.task 'default', ['vendor:js', 'assets:js', 'assets:css', 'ngm:main']
