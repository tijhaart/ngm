express =     require 'express'

module.exports = (options, imports, register)->

  server      = express()
  config      = imports.config
  port        = config.serverPort
  clientPath  = config.clientPath

  server.use express.static clientPath

  console.log config.routes

  register null,
    server:
      instance: server 
      start: ->
        console.log '[express] %s', 'starting server on port ', port
        server.listen port, (err)->
          console.log '[express] server running on port %s', port
      stop: ->
        console.log '[express] %s', 'stopping server'