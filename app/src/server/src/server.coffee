loopback = require 'loopback'
lbBoot   = require 'loopback-boot'
_        = require 'lodash' # make globaly available via imports/architect


module.exports = (options, imports, register)->
  models          = imports.models
  modelExplorer   = imports.modelExplorer
  rest            = imports.rest.instance
  # clientModels    = imports["models.client"]
  projectPath     = imports.config.projectPath
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

        lbBoot server, __dirname  

        server.use loopback.compress()
        server.use loopback.logger 'dev'

        restApiRoot = rest.get 'restApiRoot'
        # This will bind the rest app on the restApiRoot.
        # Example usage: localhost:3000/api/<resource>
        server.use restApiRoot, rest

        # create all the registered models via loopback.createModel {modelCfg}
        models.attachModels(rest).then ->

          # view REST API endopoint for the models 
          # via /model-explorer (default route)
          modelExplorer
            rest: rest
            server: server

          # rest.use loopback.bodyParser()
          rest.use loopback.json()
          rest.use loopback.urlencoded()
          rest.use loopback.methodOverride()

          rest.use loopback.cookieParser 'secret...f00b@r'
          rest.use loopback.token model: rest.models.accessToken

          serverUse [
            loopback.urlNotFound(),
            loopback.errorHandler()
          ]

          rest.enableAuth()

          console.log '[server] starting server'
          server.listen 3000, ()->
            baseUrl = 'http://' + (server.get('host') or '0.0.0.0') + ':' + server.get('port')
            console.log '[server] server started at: %s', baseUrl
      useStatic: (dir)->
        server.use loopback.static dir