loopback = require 'loopback'
lbBoot   = require 'loopback-boot'

module.exports = (options, imports, register)->
  rest = loopback()

  lbBoot rest, __dirname
  rest.use loopback.rest()

  register null,
    rest:
      instance: rest