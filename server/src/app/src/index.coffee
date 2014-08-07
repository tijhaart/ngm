lb 				= require 'loopback'

module.exports = 
	id: 'server'
	consumes: [
		'hub',
		'$log', 
		'$config',
		'rest',
		'rest.explorer',
		'angularSpa'
	]
	provides: ['server']

module.exports.setup = (options, imports, register)->
	hub 		= imports['hub']
	log 		= imports['$log'] 'server'
	config 	= imports['$config'] server
	rest 		= imports['rest'].app
	spa 		= imports['angularSpa'].app
	explorer = imports['rest.explorer']

	log.debug 'Creating loopback app: server'

	config.defaults
		viewEngine: 'jade'
		port: 3000
		host: 'localhost'

	server = lb()

	# Configure server
	server.set 'view engine', config.viewEngine
	server.set 'host', config.host

	# Middleware (1)
	server.use lb.compress()
	server.use lb.logger 'dev' # note: set dev or production based on NODE_ENV

	# Routes
	server.use rest.get('restApiRoot'), rest
	server.use '/rest-explorer', explorer
	server.use spa.get('spaAppRoot'), spa

	# Middelware (2)
	server.use lb.urlNotFound()
	server.use lb.errorHandler()

	hub.on 'ready', ->
		server.listen config.port, ->
			network = this.address()
			baseUrl = 'http://' + (server.get('host') or network.address) + ':' + network.port
			log.info 'Server started at ' + baseUrl

	register null,
		server:
			app: server