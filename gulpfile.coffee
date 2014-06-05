gulp        = require 'gulp'
gutil       = require 'gulp-util'
glob        = require 'glob'
through     = require 'through2'
es          = require 'event-stream'
_           = require 'lodash'

ngm         = require './build-support/ngm'
imports     = require './build-support/gulp-imports'

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

ngmodulesGlob = './client/src/ng-modules/**/src'

###
  Given gulp is running
  When a new module is created
  Then it should create the ng module tasks
  And run all of them
--
  Then it should create a single module (virtual) file per module
  And it should combine all the modules into a single (virtual) file

  

  gulp.src modules
    .pipe module.task('coffee')
    .pipe concat 'app.js'
    .pipe gulp.dest '.tmp/'
  
  gulp.src modules
  # run the coffee task on module basis
  # and add the output to file.contents in the stream
  .pipe ngmodules.task('coffee') 
  .pipe concat 'app.js'
  .pipe gulp.dest '.tmp/js'

  ngmodule = (path)->
    module = new NGModule path: path

  ngmodules = glob.sync modules

  ngmodules.forEach (path)->
    ngmodule(path)
      .setTasks()
      .runTasks()

  gulp.watch modules, (path)->
    # only on new modules
    ngmodule(path)
      .setTasks()
      .runTasks()

###

# https://github.com/gulpjs/gulp/blob/master/docs/recipes/running-task-steps-per-folder.md
# runTaskPerModule = (taskId)->
#   tasks = []
#   stream = 
#     start: null
#     end: null
#   finish = null

#   stream.start = (file, encoding, next)->
#     self = this

#     ngmodule = new ngm.module path: file.path

#     filesToWatch = ngmodule.path + '/**/*.coffee'
#     watching     = null

#     coffeeTask = ->
#       gulp.src filesToWatch
#         .pipe cached ngmodule.name
#         .pipe coffee bare:true
#         .pipe remember ngmodule.name
#         .pipe concat ngmodule.name + '.js'
#         .pipe wrap ';(function(angular){<%= contents %>})(angular);'
#         .pipe pretty()
#         # .pipe gulp.dest '.tmp/'
#         # .on 'data', (_file)->
#         #   # if !watching
#         #   next(null, _file)
          

#     tasks.push coffeeTask

#     gulp.watch filesToWatch, ->
#       # watching = true
#       console.log arguments
#       finish()

#     next()

#   stream.end = (next)->   
#     finish = ->
#       _tasks = tasks.map (task)-> task()

#       (es.concat.apply null, _tasks)
#         .pipe concat 'app.js'
#         .pipe gulp.dest '.tmp/js'
#         .on 'end', next

#     finish()

#   return through.obj stream.start, stream.end

# gulp.task 'default', ['ngm:modules']
# gulp.task 'ngm:modules', ->

#   # todo = new ngm.module(path:'./client/src/ng-modules/todo/src')

#   gulp.src ngmodulesGlob, read: false
#     .pipe runTaskPerModule('coffee')
#     # .pipe concat 'app.js'
#     # .pipe gulp.dest '.tmp/js'


# read modules
# write into single module
  # src coffee file
  # cache
  # coffee
  # remember
  # concat
  # wrap
# write to app.js

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
    .pipe remember ngmodule.name + ':coffee'
    .pipe concat ngmodule.name + '.js'
    .pipe wrap ';(function(angular){<%= contents %>})(angular);'

jadeTask = (ngmodule)->
  gulp.src ngmodule.path + '/templates/**/*.jade'
    .pipe cached ngmodule.name + ':jade'
    .pipe jade()
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

runServerTask = ->
  return require('./app/src')()

gulp.task 'default', ['develop']
gulp.task 'develop', ['ngm:app.js', 'ngm:app.css', 'vendor.js', 'watch']

gulp.task 'ngm:app.js', ->
  # tasks = ngmodules [jadeTask, coffeeTask]
  # tasks.push ngmMainTask()

  streamqueue(
    {objectMode: true},
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
    .pipe gulp.dest 'dist/public/css'

gulp.task 'vendor.js', ->
  jsVendorTask()
    .pipe gulpif( not CONFIG.isDev(), uglify() )
    .pipe gulp.dest 'dist/public/vendor'

gulp.task 'vendor.css', ->

gulp.task 'server:run', ->
  runServerTask()

gulp.task 'watch', ->
  # currently works only for existing files
  gulp.watch './client/src/ng-modules/**/src/**/*.coffee', ['ngm:app.js']
  gulp.watch './client/src/ng-modules/ngm-main.coffee', ['ngm:app.js']

  gulp.watch [
    './client/src/ng-modules/**/src/styles/*.scss',
    './client/src/css/**/*.scss'], ['ngm:app.css']

  gulp.watch ['./client/src/vendor/**/*.js'], ['vendor.js']