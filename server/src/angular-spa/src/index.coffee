lb = require 'loopback'

module.exports = 
	consumes: [
		'$config', 
		'$log',
		'util'
	]
	provides: ['angularSpa']

module.exports.setup = (options, imports, register)->
	log 		= imports['$log'] 'Angular SPA'
	config 	= imports['$config'] 'angularSpa'
	$path 	= imports['util'].path

	log.debug 'Creating Loopback app: spa'

	config.defaults
		# public should be a symlink to "<project>/dist/public"
		staticDir: ($path.join __dirname, 'public')
		mediaDir: ($path.join __dirname, 'media')
		spaAppRoot: '/app'

	spa = lb()

	# Middleware
	spa.use lb.static config.staticDir
	spa.use lb.static config.mediaDir

	# Configure
	spa.set 'spaAppRoot', config.spaAppRoot

	# Route(s)
	spa.get '/*', (req, res, next)->
		log.debug "#{req.method} #{req.url}"

		res.render __dirname + '/templates/angular-app', 
			isDev: true
			isHybridBuild: false
			app:
				version: 123 # todo use package.json version from <project>
				route: config.spaAppRoot


	register null,
		'angularSpa':
			app: spa