module.exports.prepEnv = ->
	# given/when/then
	require 'mocha-cakes'

	# assertions
	global.expect = (require 'chai').expect
	global.request = require 'supertest'

	return this

module.exports.prepEnv()