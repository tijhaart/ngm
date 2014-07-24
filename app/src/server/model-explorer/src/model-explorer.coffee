lbExplorer = require 'loopback-explorer'
_          = require 'lodash'

module.exports = (options, imports, register)->
  register null,
    modelExplorer: (opts)->
      _.defaults opts,
        server: null
        rest: null
        route: '/model-explorer'

      modelExplorer = lbExplorer opts.rest, basePath: (opts.rest.get 'restApiRoot' or '/api')
      opts.server.use opts.route, modelExplorer

      return modelExplorer
