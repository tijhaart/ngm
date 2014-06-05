routes      = require './_routes'
fs          = require 'fs'
Path        = require 'path'
_           = require 'lodash'

module.exports = (options, imports, register)->

  server      = imports.server
  app         = server.instance
  clientPath  = imports.config.clientPath

  isDev = process.env.NODE_ENV == 'develop'

  server.useStatic clientPath

  # staticImports = require (Path.join clientPath, 'imports.json')

  staticImports = 
    css: ['css/app.css']
    js: ['vendor/vendor.js', 'js/app.js']


  _.defaults staticImports,
    css: []
    js: []

  app.get '/app', routes.app(imports:staticImports, isDev: isDev)


  register null