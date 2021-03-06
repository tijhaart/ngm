architect   = require 'architect'
Promise     = require 'bluebird'
_           = require 'lodash'
yargs       = require 'yargs'
color       = require 'chalk'

startServer = Promise.pending()
cliArgs     = yargs.argv

if cliArgs.run or require.main == module
  startServer.resolve()



###*
 * @todo create architect config with glob/mimnatch pattern
 * @type {[type]}
###
config = (require './.architect').depedencies or []
tree = architect.resolveConfig config, __dirname

architect.createApp tree, (err, app)->
  throw err if err 

  console.log color.blue('[architect]') + ' tree resolved'
  
  services = app.services
  server   = services.server

  startServer.promise.then -> server.start()

  # server.start()
module.exports = -> startServer.resolve(); return startServer.promise