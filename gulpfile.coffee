gulp        = require 'gulp'
gutil       = require 'gulp-util'
glob        = require 'glob'
through     = require 'through2'
es          = require 'event-stream'
_           = require 'lodash'
Path        = require 'path'
yargs       = require 'yargs'
streamqueue = require 'streamqueue'
bower       = require 'bower'
log4js      = require 'log4js'

ngm         = require './build-support/ngm'
imports     = require './build-support/gulp-imports'
# Server      = require('./app/src')

coffee      = require 'gulp-coffee'
concat      = require 'gulp-concat'
wrap        = require 'gulp-wrap'
cached      = require 'gulp-cached'
remember    = require 'gulp-remember'
jade        = require 'gulp-jade'
ngtpl       = require 'gulp-angular-templatecache'
sass        = require 'gulp-sass'
plumber     = require 'gulp-plumber'
gulpif      = require 'gulp-if'
nginject    = require 'gulp-angular-injector'
clean       = require 'gulp-clean'
rename      = require 'gulp-rename'
gettext     = require 'gulp-angular-gettext'
shell       = require 'gulp-shell'
prepend     = require('gulp-insert').prepend

# develop
sourcemaps  = require 'gulp-sourcemaps'
livereload  = require 'gulp-livereload'
pretty      = require 'gulp-js-prettify'

# optimize
imgmin      = require 'gulp-imagemin'
cssmin      = require 'gulp-minify-css'
uglify      = require 'gulp-uglify'

# test
protractor  = require('gulp-protractor').protractor
karma       = require 'gulp-karma'
mocha       = require 'gulp-mocha'


gulp.task 'test:backend', ->
  global.__base = (path)-> __dirname + path

  gulp.src 'server/src/**/test/*.coffee', read: false
    # reporters: "mocha --reporters"
    .pipe mocha
      reporter: 'doc'

    # .on 'error', gutil.log

gulp.task 'testlive:backend', ->
  gulp.watch 'server/src/**/test/*.coffee', ['test:backend']


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
    .pipe plumber()
    .pipe coffee()

coffeeTask = (ngmodule)->
  gulp.src ngmodule.path + '/**/*.coffee'
    .pipe plumber()
    .pipe cached ngmodule.name + ':coffee'
    .pipe coffee bare:true
    .pipe nginject(token:'di')
    .pipe remember ngmodule.name + ':coffee'
    .pipe concat ngmodule.name + '.js'
    .pipe wrap ';(function(angular){<%= contents %>})(angular);'

# caching fails b/c the moment a .jade file changes
# it doesn't include all template (.jade) files
jadeTask = (ngmodule)->
  gulp.src ngmodule.path + '/templates/**/*.jade'
    # .pipe cached ngmodule.name + ':jade'
    .pipe plumber()
    .pipe jade( pretty: false )
    .pipe ngtpl
      filename: ngmodule.dirName + '.tpl.js'
      root: ngmodule.name
      module: ngmodule.name
    # .pipe remember ngmodule.name + ':jade'
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
    # .pipe cached 'css:base'
    .pipe plumber()
    .pipe sass( if CONFIG.isDev() then sourceComments:'normal' )
    # .pipe remember 'css:base'

sassThemeTask = ->
  gulp.src [
    './client/src/css/theme/*.scss']
    # .pipe cached 'css:theme'
    .pipe plumber()
    .pipe sass( if CONFIG.isDev() then sourceComments:'normal' )
    # .pipe remember 'css:theme'

ngmImgTask = (ngmodule)->
  path = Path.relative './client/src/ng-modules/', ngmodule.path
  path = path.substr(0,path.lastIndexOf '/src')
  gulp.src ngmodule.path + '/img/*.{png,jpg,gif,svg,jpeg}'
    .pipe gulp.dest 'dist/public/img/' + path

bower = require './bower.json'
fs    = require 'fs'
# todo use debug with vendor namespace
logVendor = log4js.getLogger 'vendor'

jsVendorTask = ->
  paths =
    "lodash":             '/dist/lodash.js'
    "underscore.string":  '/lib/underscore.string.js'
    "moment":             '/moment.js'
    "jquery":             '/dist/jquery.js'
    "angular":            '/angular.js'
    # "breezejs":           ['/breeze.debug.js', '/labs/breeze.metadata-helper.js', '/labs/breeze.angular.js']
    "angular-animate":    '/angular-animate.js'
    "angular-sanitize":   '/angular-sanitize.js'
    "angular-resource":   '/angular-resource.js'
    "angular-ui-router":  '/release/angular-ui-router.js'
    "ionic":              ['/js/ionic.js', '/js/ionic-angular.js']
    # "lb-services":        '/index.js'
    # "angular-gettext":    '/dist/angular-gettext.js'

  # @Todo: include setting verbose to true/false for showing verbose/debug output
  verbose = true

  buildSrcPath = (vendorRoot, filename)->
    source = Path.join 'client/src/vendor', vendorRoot, filename

    if verbose
      exists = fs.existsSync source
      if not exists then logVendor.error "404 - #{source}"

    return source

  # this will maintain the order set in in bower.json
  sources = _.reduce bower.dependencies, (sources, version, index)->
    # will also include local vendor scripts b/c bower installs and copies to vendor dir

    if _.isArray paths[index]
      _.forEach paths[index], (filename)->
        sources.push buildSrcPath index, filename
    else if paths[index]
      sources.push buildSrcPath index, paths[index]
    return sources
  , []

  # @todo use browserify to include visiomedia/debug
  #sources.unshift "node_modules/debug/browser.js"

  gulp.src sources
    .pipe cached 'vendor:js'
    .pipe concat 'vendor.js'
    .pipe remember 'vendor.js'

jsTask = ->
  js = ->
    gulp.src 'client/src/js/*.js', ->

  coffeeJs = ->
    gulp.src 'client/src/js/*.coffee'
      .pipe plumber()
      .pipe coffee( bare: true )

  es.concat js(), coffeeJs()

gulp.task 'default', ['develop'], ->
gulp.task 'clean', ->
  gulp.src './dist', read: false
    .pipe clean()
gulp.task 'build', ['ngm:app.js', 'ngm:app.css', 'vendor:js','vendor:fonts', 'client:img', 'ngm:img', 'ngm:i18n']
gulp.task 'develop', ['server:run', 'watch']

gulp.task 'client:img', ->
  gulp.src 'client/src/img/**/*.{png,jpg,gif,svg,jpeg}'
    .pipe cached 'client:img'
    .pipe gulpif not CONFIG.isDev(), imgmin()
    .pipe remember 'client:img'
    .pipe gulp.dest 'dist/public/img'

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

gulp.task 'ngm:img', ->
  ngmodules ngmImgTask

gulp.task 'vendor:js', ->
  jsVendorTask()
    .pipe gulpif( not CONFIG.isDev(), uglify() )
    .pipe gulp.dest 'dist/public/vendor'

# ionic gets included (scss) via client/scr/css/base
gulp.task 'vendor.css', ->

gulp.task 'vendor:fonts', ->
  gulp.src 'client/src/vendor/ionic/fonts/*.{eot,svg,ttf,woff}'
    .pipe gulp.dest 'dist/public/fonts'

isRunning = false
runServer = ->
  if not isRunning
    nodemon = require 'nodemon'
    # nodemon '--ignore ./* app/src/index.coffee'
    nodemon
      script: 'server/src/index.coffee'
      ignore: ['client', 'dist', 'build-support', 'docs', 'node_modules', 'test', '.{js,md}']

    isRunning = true

gulp.task 'server:standalone', -> runServer(); return

gulp.task 'server:run', ['build'], ->
  runServer()
  return

gulp.task 'test:unit', ->
  gulp.src './fake-path/so-plugin/uses-config'
    .pipe karma
      configFile: './test/karma.conf.coffee'
      action: 'watch'
    .on 'error', (err)->
      console.log err

# e2e: End to end or integration testing
# todo: run tests with a production task that set the NODE_ENV to production
#       which will in turn should minify/optimize the static files
gulp.task 'test:e2e', ['develop'], ->
  gulp.src './foo'
    .pipe protractor
      configFile: 'test/protractor.conf.js'
    .on 'error', (err)->
      throw Error err

gulp.task 'ngm:i10n', ->
  gulp.src 'client/src/**/*.jade'
    .pipe jade pretty:false
    .pipe gettext.extract 'template.pot'
    .pipe gulp.dest 'client/src/lang/pot'

gulp.task 'ngm:i18n', ->
  gulp.src 'client/src/lang/po/*.po'
    .pipe gettext.compile format: 'json'
    .pipe gulp.dest 'dist/public/lang'

# requires gulp-shell
gulp.task 'project:install', shell.task(['npm install', 'bower install'])

gulp.task 'publish', ->
  # set env to production
  # build
  # test
  # bump semver
  # generate docs
  # commit
  # create release (git flow)
  return
gulp.task 'ngm:docs', ->

gulp.task 'watch', ['build'], ->
  lr = livereload()
  # glob pattern "/**/src/**/*" doesn't work on new files
  # @todo: use working pattern ng-modules/**/* and then filter with /**/src/* to filter out modules
  gulp.watch [
    'client/src/js/*.{js,coffee}',
    'client/src/ng-modules/**/src/**/*.{coffee,jade}',
    'client/src/ng-modules/ngm-main.coffee'], ['ngm:app.js']

  gulp.watch [
    'client/src/ng-modules/**/src/styles/*.scss',
    'client/src/css/**/*.scss'], ['ngm:app.css']

  gulp.watch ['client/src/vendor/**/*.js'], ['vendor:js']

  gulp.watch [
    'dist/public/**/*.{js,css,png,jpg,gif,svg,jpeg}',
    'server/{src,plugins}/**/*'], (change)->
    log.info "[#{change.type}] #{Path.relative './', change.path}"
    # Full page reload
    # https://github.com/vohof/gulp-livereload/issues/7
    lr.changed path: 'index.html'

  # gulp.watch 'app/{src,plugins}/**/*', (change)->
  #   console.log 'reload server side app'

  gulp.watch 'client/src/img/**/*.{png,jpg,gif,svg,jpeg}', ['client:img']
  gulp.watch 'client/src/ng-modules/**/*.{png,jpg,gif,svg,jpeg}', ['ngm:img']