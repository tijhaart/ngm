$autoload = require 'architect-autoloader'
log 			= (require 'log4js').getLogger 'architect'
$path 		= require 'path'
$hooki 		= require './common/hooki/src'

module.exports = createArchitectApp = ->

	# creates a list of paths that contains the .module file
	$autoload.findPlugins("#{__dirname}/**/.module")
		# load the plugins
		.then($autoload.requirePlugins)
		# search plugins for the hooki object
		# and inject the $hooki architect plugin
		.then($hooki.architect())
		# create the architect app
		.then( $autoload.createApp __dirname)
		# app is succesfully build by Architect
		.then((app)->
			app.services['server'].start()
			return app
		)
		# something broke and the app isn't created
		.catch((err)->
			log.error err
		)

if require.main == module
	createArchitectApp()