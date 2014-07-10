lbNg    = require 'loopback-sdk-angular'
fs      = require 'fs'
Path    = require 'path'
_       = require 'lodash'

module.exports = (options, imports, register)->

  register null,
    "models.client":
      generate: (opts)->
        _.defaults opts,
          restApiRoot: null
          app: null
          ngModuleName: 'lbServices'
          path: (Path.resolve __dirname, 'lbServices.js')

        generatedCode = lbNg.services opts.app, opts.ngModuleName, opts.restApiRoot
        fs.writeFileSync opts.path, generatedCode