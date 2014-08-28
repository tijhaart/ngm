module.exports.prepEnv = ->
  # given/when/then
  require 'mocha-cakes'

  global.expect = (require 'chai').expect
  global.request = require 'supertest'

  global.__base = (path)->
    __dirname + path

  return

module.exports.prepEnv()