architect   = require 'architect'
Promise     = require 'bluebird'
_           = require 'lodash'
yargs       = require 'yargs'
color       = require 'chalk'
glob        = require 'glob'
$path       = require 'path'

startServer = Promise.pending()
cliArgs     = yargs.argv

if cliArgs.run or require.main == module
  startServer.resolve()

getPackgesCfg = ->
  packages = [
    __dirname + '/**/package.json',
    'plugins' + '/**/package.json'
  ]
  base = $path.resolve __dirname, '../'
  pluginPaths = _.reduce packages, (pluginPaths, pluginGlob)->

    paths = glob.sync pluginGlob #($path.relative __dirname, pluginGlob)
    paths = paths.map (path)-> "./#{$path.dirname ($path.relative base, path)}"

    if paths.length
      return pluginPaths.concat paths  

    return pluginPaths
  , []

  # @TODO allow packages defined in architect.json also to be loaded (e.g. external modules from npm)

  return packagesCfg = (architect.resolveConfig pluginPaths, base)

architect.createApp getPackgesCfg(), (err, app)->
  throw err if err 

  console.log color.blue('[architect]') + ' tree resolved'
  
  services = app.services
  server   = services.server

  startServer.promise.then -> server.start()

  # server.start()
module.exports = -> startServer.resolve(); return startServer.promise
