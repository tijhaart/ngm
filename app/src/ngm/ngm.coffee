routes      = require './_routes'

module.exports = (options, imports, register)->

  server      = imports.server
  app         = server.instance
  clientPath  = imports.config.clientPath

  server.useStatic clientPath

  app.get '/app', routes.app

  register null