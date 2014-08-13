$autoload = require 'architect-autoloader'
log 			= (require 'log4js').getLogger 'architect'
$path 		= require 'path'

module.exports = createArchitectApp = ->

	$autoload("#{__dirname}/**/.module", __dirname)
		.then( (architectApp)->

			architectApp.services.app.start()

			return architectApp
		)
		.catch (err)->
			log.error err

if require.main == module
	createArchitectApp()