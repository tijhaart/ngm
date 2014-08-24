lb 					= require 'loopback'
$explorer 	= require 'loopback-explorer'

module.exports = 
	id: 'rest'
	consumes: [
		'$config', 
		'$log', 
		'rest.models', 
		'hub', 
		'util'
	]
	provides: ['rest', 'rest.explorer']

module.exports.setup = (options, imports, register)->
	hub 			= imports['hub']
	config 		= imports['$config'] options.id
	log 	 		= imports['$log'] options.id
	models 		= imports['rest.models']
	_ 				= imports['util'].lodash
	$promise 	= imports['util'].promise
	$hooki 		= imports['util'].$hooki

	log.setLevel 'info'

	# rest.dataSources
	dataSources = 
		db:
			connector: 'memory'
			defaultForType: 'db'

	# clean up Architect leftovers
	delete models['name']

	log.info 'Creating loopback app: rest'

	config.defaults
		restApiRoot: '/api/0'
		host: 'localhost'
		cookieSecret: 'secr3t_f00b@r'

	rest = lb()

	# Configure loopback rest app
	rest.set 'restApiRoot', config.restApiRoot

	# Middleware (1)
	rest.use lb.rest()
	rest.use lb.json()
	rest.use lb.urlencoded(extended:true)
	rest.use lb.methodOverride()
	rest.use lb.cookieParser config.cookieSecret
	rest.use lb.token model: models.accessToken

	# Configure and attach models
	rest.dataSource 'db', dataSources.db

	_.forEach models, (model, key)->
		log.debug 'Attaching model:', key
		model.attachTo rest.dataSources.db
		rest.model model
		return

	# Middleware (2)
	# loopback enableAuth: https://github.com/strongloop/loopback/blob/b66a36fd3c7993f6808ba786a472e0c598d00963/lib/application.js#L296
	rest.enableAuth()

	register null,
		rest:
			app: rest
		'rest.explorer': ($explorer rest, basePath: rest.get('restApiRoot'))