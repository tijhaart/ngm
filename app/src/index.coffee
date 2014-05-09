architect   = require 'architect'


###*
 * @todo create architect config with glob/mimnatch pattern
 * @type {[type]}
###
config = (require './.architect').depedencies or []

tree = architect.resolveConfig config, __dirname

architect.createApp tree, (err, app)->
  console.log '[architect] tree resolved'
  
  services = app.services
  server   = services.server

  # server.start()
