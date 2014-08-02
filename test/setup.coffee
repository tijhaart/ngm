module.exports.prepEnv = ->
	# given/when/then
	require 'mocha-cakes'

	# assertions
	global.expect = (require 'chai').expect

	return this