lbExplorer = require 'loopback-explorer'

module.exports = (options, imports, register)->

  rest    = imports.rest.instance
  server  = imports.server.instance 

  restApiRoot = rest.get 'restApiRoot'
  modelExplorer = lbExplorer rest, basePath: restApiRoot

  server.use '/model-explorer', modelExplorer
  # doesn't get fired at all
  server.once 'started', (baseUrl)->
    console.log 'Model explorer: %s%s', baseUrl, modelExplorer.mountPath

  register null,
    modelExplorer: modelExplorer