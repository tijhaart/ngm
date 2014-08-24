(require __base '/test/setup').prepEnv()

# DISABLED
return 

_ 					= require 'lodash'
autoloader 	= require 'architect-autoloader'
logger 			= require 'log4js'

testId = 'user.model.test.integration'

# @todo make configurable via prepEnv(logToFile: 'path/to/logfile.log')
# logger.clearAppenders()

log = logger.getLogger testId
# clears earlier logged messages when watching files
log.removeAllListeners 'log'
logger.loadAppender 'file'
logger.addAppender logger.appenders.file("#{__dirname}/logs/#{testId}.log"), testId


appCreated = autoloader.findPlugins(__base '/server/**/.module')
	.then(autoloader.requirePlugins)
	.then(autoloader.filter('rest'))
	.then( autoloader.createApp( (__base '/server/src'), resolvedApp: false ) )
	.then( (app)->		

		return app.$promise
	)

describe 'User model (integration)', ->
	rest = null
	model = null

	server = null

	before (done)->
		appCreated.then (app)->			
			rest = app.services.rest.app
			model = rest.models.user

			server = rest.listen 3000, ->
				log.info this.address()
				done()

			return app
		.catch done

	after ->
		server.close()

	# test user api

	Scenario "Create a new user", ->
		user = null

		after ->
			user = null
			return

		Given "user John Doe with username, email and password", ->
			user =
				username: 'johndoe'
				email: 'jonhndoe@example.com',
				password: 'demo'
			return

		When "POST user to /users", (done)->

			request(rest)
				.post '/users'
				.send user
				.expect 200
				.type 'application/json'
				.end (err, res)->

					log.debug res.body

					done.apply null, arguments

			return
			

		Then "Should have created the user", (done)->

			process.nextTick done

		return	