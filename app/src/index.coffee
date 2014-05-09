architect   = require 'architect'

config = (require './.architect').depedencies or []

tree = architect.resolveConfig config, __dirname

architect.createApp tree, (err, app)->
  console.log '[architect] tree resolved'
  
  services = app.services
  server   = services.server

  server.start()
