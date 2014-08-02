architect   = require 'architect'
Promise     = require 'bluebird'
_           = require 'lodash'
yargs       = require 'yargs'
color       = require 'chalk'
glob        = require 'glob'
$path       = require 'path'
log         = (require 'log4js').getLogger('[architect]')

startServer = Promise.pending()
cliArgs     = yargs.argv

if cliArgs.run or require.main == module
  startServer.resolve()

getPackgesCfg = ->
  base = $path.resolve __dirname, '../'
  packages = [
    __dirname + '/**/package.json'
    base + '/plugins' + '/**/package.json'
  ]
  log.info 'searching architect packages'

  pluginPaths = _.reduce packages, (pluginPaths, pluginGlob)->
    globbed = Promise.pending()

    glob pluginGlob, (err, result)->
      throw err if err
      paths = result.map (path)-> "./#{$path.dirname ($path.relative base, path)}"
      globbed.resolve paths 

    pluginPaths.push globbed.promise

    return pluginPaths
  , []

  Promise.all(pluginPaths).then (paths)->
    paths = paths.concat.apply([], paths)
    return architect.resolveConfig paths, base

  # @TODO allow packages defined in architect.json also to be loaded (e.g. external modules from npm)

getPackgesCfg().then (packages)->
  architect.createApp packages, (err, app)->
    throw err if err 

    log.info 'app ready'
    
    services = app.services
    server   = services.server

    startServer.promise.then -> 
      server.start()

  # server.start()
module.exports = -> startServer.resolve(); return startServer.promise
