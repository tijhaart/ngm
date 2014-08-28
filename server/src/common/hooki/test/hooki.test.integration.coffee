#(require __base '/test/setup').prepEnv()

_ 				= require 'lodash'
$promise 	= require 'bluebird'

autoloader = require 'architect-autoloader'
$hooki = require '../src'
Hooki = $hooki.Hooki

promisedApp = do ->
	plugins = []

	plugins.push
		consumes: ['$hooki']
		provides: ['Greeter', 'greeter']
		setup: (options, imports, register)->
			filter = (imports['$hooki'].slave name: 'greeter').filter
			defaultMessage = 'Hello world!'

			Greeter = ->
			Greeter:: =
				message: -> return filter 'message', defaultMessage

			greeter = new Greeter()

			register null, 
				Greeter: Greeter
				greeter: greeter

	plugins.push
		consumes: ['Greeter']
		provides: ['message']
		hooki:
			'greeter.message': (msg)-> return 'Hallo wereld!'
		setup: (options, imports, register)->
			greeter = new imports['Greeter']()
			message = greeter.message()

			register null, message: message

	plugins.push
		consumes: []
		provides: []
		hooki:
			'greeter.message':
				priority: 50
				filter: (msg)-> return msg + '!!'
		setup: (options, imports, register)-> register()

	pending = $promise.pending()

	app = ->
		pending.resolve plugins
		pending.promise
			.then($hooki.architect())
			.then(autoloader.createApp __dirname)


describe '$hooki.architect', ->

	Feature 'Kitchen sink', ->
		Given 'architect plugins with hooki', (done)=>
			self = this
			@pending = promisedApp()
				.then (app)-> 
					self.app = app
					done()
		When 'a filter is called', =>
			@message = @app.services.greeter.message()
		Then 'it should have used the registered filters', =>
			expect(@message).to.equal('Hallo wereld!!!')
			expect(@app.services.message).to.equal('Hallo wereld!!!')

	Feature 'multiple filters with priorities set', ->
		Given 'app with a filter and multiple priorities', =>
			@plugins = [
				{
					setup: (options, imports, register)-> register()
					consumes: []
					provides: []
					hooki:
						'greeter.message':
							priority: 60
							filter: (msg)-> 'priority-60'
				}
				{
					setup: (options, imports, register)-> register()
					consumes: []
					provides: []
					hooki:
						'greeter.message':
							priority: 10
							filter: (message)-> 'priority-10'
				}
				{
					setup: (options, imports, register)-> register()
					consumes: []
					provides: []
					hooki:
						'greeter.message':
							priority: 50
							filter: (message)-> 'priority-50'
				}
				{
					consumes: ['$hooki']
					provides: ['getMessage']
					setup: (options, imports, register)->
						filter = (imports['$hooki'].slave name: 'greeter').filter

						register(null, getMessage: -> filter 'message', 'default message')
				}
			]

		When 'the filter is applied', (done)=>
			self = this
			plugins = $hooki.architect()(@plugins)
			autoloader.createApp(__dirname)(plugins)
				.then (app)->
					self.message = app.services.getMessage()					
					done()
				.catch done
			return
		Then 'the value should contain the value returned by the filter with the highest priority (10)', =>
			expect(@message).to.equal('priority-10')

	Feature 'Clear registered filters after a filter is applied', ->

		Given 'registered filter', =>
			@plugins = [
				{
					consumes: ['$hooki']
					provides: ['bar', 'getBarAgain']
					setup: (options, imports, register)->
						filter = (imports['$hooki'].slave name: 'foo').filter

						bar = -> filter 'bar', 'bar', {clearHookies: true}

						register null, 
							bar: bar()
							getBarAgain: bar
				}
				{
					hooki:
						'foo.bar': (bar)-> 'baz'
					consumes: []
					provides: []
					setup: (options, imports, register)->register()
				}
			]
		When 'the filter is applied again', (done)=>
			self = this
			autoloader.createApp(__dirname)($hooki.architect()(@plugins)).then (app)->
				self.barA = app.services.bar
				self.barB = app.services.getBarAgain()
				done()
		Then 'it should not have run the registered filter again', =>
			expect(@barA).to.equal('baz')	
			expect(@barB).to.equal('bar')

	Feature 'hooki.config', ->

		Given 'plugins ready', =>

			@plugins = [
				{
					consumes: []
					provides: []
					hooki:
						'greeter.register.message': (register)->
							register 'Hello world!'
							register 'Hello world!'
					setup: (options, imports, register)-> register()
				}
				{
					consumes: []
					provides: []
					hooki:
						'greeter.register.message': (register)->
							register 'Hallo wereld!'
					setup: (options, imports, register)-> register()
				}
				{
					consumes: ['$hooki']
					provides: ['messages']
					setup: (options, imports, register)->
						config = (imports['$hooki'].slave name: 'greeter').config

						messages = []

						config 'register.message', (message)->
							if (messages.indexOf message) < 0
								messages.push message
								return true
							return false

						register null, messages: -> messages
				}
			]

		When 'ready', (done)=>
			self = this
			autoloader.createApp(__dirname)($hooki.architect()(@plugins)).then (app)->
				self.messages = app.services.messages()
				done()
		Then 'expect messages added', =>
			expect(@messages).to.deep.equal(['Hello world!', 'Hallo wereld!'])