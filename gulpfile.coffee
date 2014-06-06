gulp        = require 'gulp'
gutil       = require 'gulp-util'
glob        = require 'glob'
through     = require 'through2'
es          = require 'event-stream'
_           = require 'lodash'
Path        = require 'path'
yargs       = require 'yargs'

ngm         = require './build-support/ngm'
imports     = require './build-support/gulp-imports'
server      = require('./app/src')

coffee      = require 'gulp-coffee'
concat      = require 'gulp-concat'
wrap        = require 'gulp-wrap'
pretty      = require 'gulp-js-prettify'
cached      = require 'gulp-cached'
remember    = require 'gulp-remember'
jade        = require 'gulp-jade'
ngtpl       = require 'gulp-angular-templatecache'
sass        = require 'gulp-sass'
prepend     = require('gulp-insert').prepend
streamqueue = require 'streamqueue'
plumber     = require 'gulp-plumber'
uglify      = require 'gulp-uglify'
gulpif      = require 'gulp-if'
nginject    = require 'gulp-angular-injector'
livereload  = require 'gulp-livereload'
cssmin      = require 'gulp-minify-css'
clean       = require 'gulp-clean'

ngmodulesGlob = './client/src/ng-modules/**/src'

log     = gutil.log
loggers =
  'info':     'blue'
  'success':  'green'
  'err':      'red'
  'warn':     'yellow'
  'debug':    'magenta'
_.forEach loggers, (color, index)->
  log[index] = ->
    args = Array.prototype.splice.apply arguments, arguments
    args.unshift "[#{gutil.colors[color](index)}]"
    gutil.log.apply gutil.log, args

process.env.NODE_ENV = 'develop'

CONFIG =
  dev: true
  isDev: ->
    return this.dev

###*
 * Call tasks with ng-module meta
 * @param  {[type]} task [description]
 * @param  {[type]} cfg  Configuration
 * @return {[type]}      [description]
###
ngmodules = (task)->

  tasks = (glob.sync ngmodulesGlob).reduce (tasks, pathToModule)->
    ngmodule = new ngm.module path: pathToModule

    if _.isArray task
      task.forEach (_task)-> tasks.push _task(ngmodule)
    else
      tasks.push task(ngmodule)

    return tasks
  , []
ngmodules.join = (tasks)-> (es.concat.apply null, tasks)

ngmMainTask = ->
  gulp.src './client/src/ng-modules/ngm-main.coffee'
    .pipe coffee()

coffeeTask = (ngmodule)->
  gulp.src ngmodule.path + '/**/*.coffee'
    .pipe cached ngmodule.name + ':coffee'
    .pipe coffee bare:true
    .pipe nginject(token:'di')
    .pipe remember ngmodule.name + ':coffee'
    .pipe concat ngmodule.name + '.js'
    .pipe wrap ';(function(angular){<%= contents %>})(angular);'

jadeTask = (ngmodule)->
  gulp.src ngmodule.path + '/templates/**/*.jade'
    .pipe cached ngmodule.name + ':jade'
    .pipe jade( pretty: false )
    .pipe ngtpl
      filename: ngmodule.dirName + '.tpl.js'
      root: ngmodule.name
      module: ngmodule.name
    .pipe remember ngmodule.name + ':jade'
    .pipe concat ngmodule.name + '.tpl.js'

sassTask = (ngmodule)->
  opts =
    sass:
      includePaths: ['./client/src/css/theme']

  if CONFIG.isDev() then opts.sass.sourceComments = 'normal'  

  gulp.src ngmodule.path + '/styles/*.scss'
    # .pipe cached ngmodule.name + ':sass'
    .pipe plumber()
    # .pipe prepend '@import "client/src/css/theme/theme_config";' + "\n" # <- fails b/c of sourceComments
    .pipe sass(opts.sass)
    # .pipe remember ngmodule.name + ':sass'
    .pipe concat ngmodule.name + '.css'

sassBaseTask = ->
  gulp.src [ 
    './client/src/css/base/**/*.scss']
    .pipe cached 'css:base'
    .pipe plumber()
    .pipe sass( if CONFIG.isDev() then sourceComments:'normal' )
    .pipe remember 'css:base'  

sassThemeTask = ->
  gulp.src [ 
    './client/src/css/theme/*.scss']
    .pipe cached 'css:theme'
    .pipe plumber()    
    .pipe sass( if CONFIG.isDev() then sourceComments:'normal' )
    .pipe remember 'css:theme'

jsVendorTask = ->
  bower = require './bower.json'
  # this will maintain the order set in in bower.json
  sources = _.map bower.dependencies, (vendor, index)->
    # will also include local vendor scripts b/c bower installs and copies to vendor dir
    return "client/src/vendor/#{index}/index.js" 
  gulp.src sources
    .pipe cached 'vendor:js'
    .pipe concat 'vendor.js'
    .pipe remember 'vendor.js'

jsTask = ->
  js = ->
    gulp.src 'client/src/js/*.js', ->

  coffeeJs = ->
    gulp.src 'client/src/js/*.coffee'
      .pipe coffee( bare: true )

  es.concat js(), coffeeJs()

gulp.task 'default', ['develop'], ->
gulp.task 'clean', ->
  gulp.src './dist', read: false
    .pipe clean()
gulp.task 'build', ['ngm:app.js', 'ngm:app.css', 'vendor.js']
gulp.task 'develop', ['server:run', 'watch']

gulp.task 'ngm:app.js', ->
  # tasks = ngmodules [jadeTask, coffeeTask]
  # tasks.push ngmMainTask()

  streamqueue(
    {objectMode: true},
    jsTask(),
    ngmodules.join(ngmodules coffeeTask),
    ngmodules.join(ngmodules jadeTask),
    ngmMainTask()
  )
    .pipe concat 'app.js'
    .pipe ( if CONFIG.isDev() then pretty() else uglify() )
    .pipe gulp.dest 'dist/public/js'

gulp.task 'ngm:app.css', ->
  ###
    clear cache when sassBaseTask or sassBaseTask files changed
    and re-run this task because dependent modules don't get updated
    after such a change because the module file itself hasn't changed
  ###
  streamqueue( 
    {objectMode: true},
    sassBaseTask(),
    ngmodules.join(ngmodules sassTask), 
    sassThemeTask() 
  )
    .pipe concat 'app.css'
    .pipe gulpif not CONFIG.isDev(), cssmin()
    .pipe gulp.dest 'dist/public/css'

gulp.task 'vendor.js', ->
  jsVendorTask()
    .pipe gulpif( not CONFIG.isDev(), uglify() )
    .pipe gulp.dest 'dist/public/vendor'

gulp.task 'vendor.css', ->

gulp.task 'server:run', ['build'], ->
  server()

gulp.task 'publish', ->
  # set env to production
  # build
  # test
  # bump semver
  # commit
  # create release (git flow)
  return
gulp.task 'ngm:docs', ->
  # generate ng doc reference
  return

gulp.task 'watch', ['build'], ->
  lr = livereload()
  # currently works only for existing files
  gulp.watch [
    'client/src/js/*.{js,coffee}',
    'client/src/ng-modules/**/src/**/*.coffee', 
    'client/src/ng-modules/ngm-main.coffee'], ['ngm:app.js']

  gulp.watch [
    'client/src/ng-modules/**/src/styles/*.scss',
    'client/src/css/**/*.scss'], ['ngm:app.css']

  gulp.watch ['client/src/vendor/**/*.js'], ['vendor.js']

  gulp.watch 'dist/public/**/*.{js,css}', (change)->
    log.info "[#{change.type}] #{Path.relative './', change.path}"

    # Full page reload
    # https://github.com/vohof/gulp-livereload/issues/7
    lr.changed path: 'index.html' 