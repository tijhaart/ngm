gulp        = require 'gulp'
gutil       = require 'gulp-util'
glob        = require 'glob'
through     = require 'through2'
es          = require 'event-stream'

ngm         = require './build-support/ngm'

coffee      = require 'gulp-coffee'
concat      = require 'gulp-concat'
wrap        = require 'gulp-wrap'
pretty      = require 'gulp-js-prettify'
cached      = require 'gulp-cached'
remember    = require 'gulp-remember'

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
runTaskPerModule = (taskId)->
  tasks = []
  stream = 
    start: null
    end: null
  finish = null

  stream.end = (next)->   
    finish = ->
      _tasks = tasks.map (task)-> task()

      (es.concat.apply null, _tasks)
        .pipe concat 'app.js'
        .pipe gulp.dest '.tmp/js'
        .on 'end', next

    finish()

  stream.start = (file, encoding, next)->
    self = this

    ngmodule = new ngm.module path: file.path

    filesToWatch = ngmodule.path + '/**/*.coffee'
    watching     = null

    coffeeTask = ->
      gulp.src filesToWatch
        .pipe cached ngmodule.name
        .pipe coffee bare:true
        .pipe remember ngmodule.name
        .pipe concat ngmodule.name + '.js'
        .pipe wrap ';(function(angular){<%= contents %>})(angular);'
        .pipe pretty()
        # .pipe gulp.dest '.tmp/'
        # .on 'data', (_file)->
        #   # if !watching
        #   next(null, _file)
          

    tasks.push coffeeTask

    gulp.watch filesToWatch, ->
      # watching = true
      console.log arguments
      finish()

    next()


  return through.obj stream.start, stream.end

gulp.task 'default', ['ngm:modules']
gulp.task 'ngm:modules', ->

  # todo = new ngm.module(path:'./client/src/ng-modules/todo/src')

  gulp.src ngmodulesGlob, read: false
    .pipe runTaskPerModule('coffee')
    # .pipe concat 'app.js'
    # .pipe gulp.dest '.tmp/js'
