routes      = require './_routes'
fs          = require 'fs'
Path        = require 'path'
_           = require 'lodash'

module.exports = (options, imports, register)->

  server      = imports.server
  app         = server.instance
  clientPath  = imports.config.clientPath

  server.useStatic clientPath

  staticImports = require (Path.join clientPath, 'imports.json')

  _.defaults staticImports,
    css: []
    js: []

  app.get '/app', routes.app(imports:staticImports)


  register null