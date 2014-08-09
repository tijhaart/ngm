$autoload = require 'architect-autoloader'
log 			= (require 'log4js').getLogger 'architect'
$path 		= require 'path'

module.exports = createArchitectApp = ->

	$autoload("#{__dirname}/**/.module", __dirname)
		.then( (app)->
			app.services.hub.on 'service', ->
				log.info 'ready', this

			return app
		)
		.catch (err)->
			log.error err

if require.main == module
	createArchitectApp()