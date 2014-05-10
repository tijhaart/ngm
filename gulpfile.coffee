glob  = require 'glob'
gulp  = require 'gulp'
gutil = require 'gulp-util'
fs    = require 'fs'
path  = require 'path'
_str  = require 'underscore.string'
es    = require 'event-stream'
_     = require 'lodash'
async = require 'async'

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

ngmodules = require './build-support/ngm-tasks'
ngm       = require './build-support/ngm'

DEST_ROOT = '.tmp/public/'
dest = (dirpath)-> path.normalize "#{DEST_ROOT}/#{dirpath}"
client = (dirpath) -> path.normalize "./client#{dirpath}" 

process.env.NODE_ENV = 'develop'
env = process.env.NODE_ENV

isDev = -> env == 'develop'

###*
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

gulp.task 'imports.json', ngmodules.$tasks['compile'], (cb)->
  imports = {}

  scripts = (glob.sync dest '/ng-modules/js/*.js').map (item)->  '/' + item.replace DEST_ROOT, ''
  styles = (glob.sync dest '/ng-modules/css/*.css').map (item)->  '/' + item.replace DEST_ROOT, ''

  imports.scripts = scripts 
  imports.styles = styles 

  # console.log imports

  fs.writeFile dest('imports.json'), JSON.stringify(imports), (err)->
    throw Error err if err
    cb()

gulp.task 'run-server', ['imports.json'], ->
  app = require('./app/src')()

gulp.task 'default', ngmodules.$tasks['compile'], ->
  # gulp.start 'livereload'
  # console.log ngmodules

# @todo use batchstream to collect multiple changes
gulp.task 'livereload', ->
  gulp.watch (dest '/**/*'), ()->
    # call lr with changes

gulp.task 'assets:css', ->
  gulp.src client '/src/assets/css/theme/theme.scss'
    .pipe sass()
    .pipe gulp.dest dest('/css/')

###*
 * @todo figure out how to include vendor:css
 * @return {[type]} [description]
###
gulp.task 'vendor:js', ->
  bower = require './bower.json'

  vendor =
    path: client '/src/assets/'
    vendors: ->
      _path = @path
      # this will maintain the order set in in bower.json
      src = _.map bower.dependencies, (vendor, index)->
        return "#{_path}/vendor/#{index}/index.js" # will also include local vendor scripts b/c bower installs and copies to vendor dir
      gulp.src src
        .pipe concat 'vendor.js'

  vendor.vendors().pipe gulp.dest dest('/vendor')


gulp.task 'assets:js', ->

  assets =
    path: client '/src/assets/'
    coffee: ->
      gulp.src (client '/src/assets/js/*.coffee'), read: false
        .pipe coffee()
    js: ->
      gulp.src @path + '/js/*.js'
    joinJS: ->
      (streamqueue objectMode:true,
        @coffee(),
        @js()
      ).pipe concat 'misc.js'

  assets.joinJS().pipe gulp.dest dest('/js')


gulp.task 'ngm:main', ['ngm:compile'], ->
  gulp.src (client '/src/ng-modules/ngm-main.coffee')
    # .pipe watch()
    .pipe coffee()
    .pipe gulp.dest dest('/ng-modules/js/')


gulp.task 'clean', ->
  gulp.src '.tmp'
    .pipe clean read: false

# gulp.task 'default', ['vendor:js', 'assets:js', 'assets:css', 'ngm:main']
