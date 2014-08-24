# (require __base '/test/setup').prepEnv()

# _ 					= require 'lodash'
# autoloader 	= require 'architect-autoloader'

# appCreated = autoloader.findPlugins(__base '/server/**/.module')
# 	.then(autoloader.requirePlugins)
# 	# mock stuff
# 	# .then (plugins)-> return <mocked plugins>
# 	.then(autoloader.filter('rest'))
# 	.then( autoloader.createApp( (__base '/server/src'), resolvedApp: false ) )
# 	.then( (app)->
# 		app.on 'service', (name, service)->
# 			if name == 'settings.development'
# 				service.server.port = 3001

# 		return app.$promise
# 	)
# 	.then (app)->
# 		console.log 
# 			modifiedSetting: app.services['settings.development'].server.port
# 			restApiRoot: app.services.rest.app.get 'restApiRoot'


	# beforeEach ->

	# afterEach ->
	# 	console.log 'destroy app'
	# 	app.destroy()

	# it 'should have attached rest models "user", "acl" and "accessToken"', ->
	# 	rest.set 'restApiRoot', '/api/1'
	# 	[
	# 		'user',
	# 		'acl',
	# 		'accessToken'
	# 	]
	# 	.forEach (model)->
	# 		expect(rest.models).to.have.property(model)

	# it 'destroy', ->
	# 	console.log app.services['rest'].app.get 'restApiRoot'

	# [
	# 	'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
	# ]
	# .forEach (letter)->
	# 	it "#{letter} should equal #{letter}", ->
	# 		expect(letter).to.equal(letter)
	# 		return