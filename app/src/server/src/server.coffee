loopback = require 'loopback'
lbBoot   = require 'loopback-boot'
_        = require 'lodash' # make globaly available via imports/architect


module.exports = (options, imports, register)->
  models          = imports.models
  modelExplorer   = imports.modelExplorer
  rest            = imports.rest.instance
  server          = loopback()

  # util
  serverUse = (middlewares)->
    _.forEach middlewares, (middleware)->
      server.use middleware
    return

  # config
  server.set('view engine', 'jade')

  register null,
    server:
      instance: server
      start: ->
        server.use loopback.compress()
        # This will bind the rest app on the restApiRoot.
        # Example usage: localhost:3000/api/<resource>
        server.use (rest.get 'restApiRoot'), rest
        # models.attachModels(rest)
        models.attachModels(rest)

        # view REST API endopoint for the models 
        # via /model-explorer (default route)
        modelExplorer
          rest: rest
          server: server

        lbBoot server, __dirname  

        serverUse [
          loopback.urlNotFound(),
          loopback.errorHandler()
        ]

        console.log '[server] starting server'
        server.listen 3000, ()->
          baseUrl = 'http://' + (server.get('host') or '0.0.0.0') + ':' + server.get('port')
          console.log '[server] server started at: %s', baseUrl
      stop: ->
      reset: ->
      useStatic: (dir)->
        server.use loopback.static dir