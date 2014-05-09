module.exports = (options, imports, register)->

  server      = imports.server
  app         = server.instance
  clientPath  = imports.config.clientPath

  server.useStatic clientPath

  app.get '/foo', (req, res)-> 

    res.render __dirname + '/templates/angular-app'

  register null