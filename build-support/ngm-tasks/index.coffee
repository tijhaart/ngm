ngm     = require '../ngm'
path    = require 'path'
gulp    = require 'gulp'
gutil   = require 'gulp-util'

DEST_ROOT = '.tmp/public/'
dest      = (dirpath)-> path.normalize "#{DEST_ROOT}/#{dirpath}"
client    = (dirpath) -> path.normalize "./client/#{dirpath}" 

modules = ngm.modules
  watch:    true
  # isDev: isDev()
  cssDest:  dest '/ng-modules/css/'
  jsDest:   dest '/ng-modules/js/'
  tplDest:  dest '/ng-modules/js/'
  src:      client '/src/ng-modules/**/src/'

['templates', 'js', 'styles'].forEach (task)->
  require('./'+task)(modules, gulp, gutil)

module.exports = modules