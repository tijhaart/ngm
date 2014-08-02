loopback = require 'loopback'
lbBoot   = require 'loopback-boot'
log 		 = (require 'log4js').getLogger 'rest'
_ 			 = require 'lodash'

module.exports = (options, imports, register)->
	bus 			= imports.bus
	model 		= imports.model
	explorer 	= imports.modelExplorer
	rest 			= loopback()

	lbBoot rest, __dirname

	accessToken = _.find model.models, name:'accessToken'

	rest.model loopback.createModel accessToken

	rest.use loopback.rest()
	rest.use loopback.json()
	rest.use loopback.urlencoded()
	rest.use loopback.methodOverride()
	rest.use loopback.cookieParser 'secret...f00b@r'

	bus.on 'server:setup', (server)->
		log.info 'setup rest for use with server'

		restApiRoot = rest.get 'restApiRoot'
		# This will bind the rest app on the restApiRoot.
		# Example usage: localhost:3000/api/<resource>
		server.use restApiRoot, rest
		rest.use loopback.token model: rest.models.accessToken

		console.log rest.models.accessToken

		explorer rest: rest, server: server

	bus.on 'server:postSetup', (server)->	
		rest.enableAuth()
		return

	register null,
	  rest:
	    instance: rest