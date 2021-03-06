routes      = require './_routes'
fs          = require 'fs'
Path        = require 'path'
_           = require 'lodash'

module.exports = (options, imports, register)->

  registerModel = imports.models.registerModel
  server        = imports.server
  app           = server.instance
  clientPath    = imports.config.clientPath

  # config: env
  isDev = process.env.NODE_ENV == 'develop'

  server.useStatic clientPath

  staticImports = 
    css: [
      # 'vendor/ionic/css/ionic.css', # 
      'css/app.css']
    js: ['vendor/vendor.js', 'js/app.js']


  _.defaults staticImports,
    css: []
    js: []

  app.get '/app', routes.app(imports:staticImports, isDev: isDev, isHybridBuild:false)
  app.get '/', (req, res)->
    res.send 'It works! <br> ' + Path.relative imports.config.projectPath, __dirname


  register null