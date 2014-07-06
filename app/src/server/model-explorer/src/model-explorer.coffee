lbExplorer = require 'loopback-explorer'
_          = require 'lodash'

module.exports = (options, imports, register)->
  ###  
  rest    = imports.rest.instance
  server  = imports.server.instance

  restApiRoot = rest.get 'restApiRoot'
  modelExplorer = lbExplorer rest, basePath: restApiRoot

  server.use '/model-explorer', modelExplorer
  # doesn't get fired at all
  server.once 'started', (baseUrl)->
    console.log 'Model explorer: %s%s', baseUrl, modelExplorer.mountPath
  ###

  register null,
    modelExplorer: (opts)->
      _.defaults opts,
        server: null
        rest: null
        route: '/model-explorer'
      
      modelExplorer = lbExplorer opts.rest, basePath: (opts.rest.get 'restApiRoot' or '/api')
      opts.server.use opts.route, modelExplorer

      return modelExplorer
