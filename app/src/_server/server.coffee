express     = require 'express'

###*
 * @todo Move server to plugins, nah...it's pretty critical for the app to function
###
module.exports = (options, imports, register)->

  server      = express()
  config      = imports.config
  port        = config.serverPort
  clientPath  = config.clientPath

  

  # server.use express.static clientPath

  # server.set('views', "/")
  server.set('view engine', 'jade')

  # server.use(express.favicon())
  # server.use(express.logger('dev'))
  # server.use(express.bodyParser())
  # server.use(express.methodOverride())
  # server.use(express.cookieParser('your secret here'))
  # server.use(express.session())
  # server.use(server.router)

  # server.get '/foo', (req, res)->
  #   res.send 'Foo'

  register null,
    server:
      instance: server 
      start: ->
        console.log '[express] Starting server on port %d', port
        server.listen port, (err)->
          console.log '[express] Listening on port %d', port
      stop: ->
        console.log '[express] %s', 'stopping server'
      useStatic: (dir)->
        server.use express.static dir