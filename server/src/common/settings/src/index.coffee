module.exports =
	consumes: [
		'$log',
		'util',
		'settings.global',
		'settings.development',
		'settings.production'
	]
	provides: ['settings']

module.exports.setup = (options, imports, register)->
	log = imports['$log'] 'settings'
	_ = imports['util'].lodash

	settings =
		development: imports['settings.development']
		production: imports['settings.production']
	globalSettings = imports['settings.global']

	globalSettings.globals = {} if not globalSettings.globals

	env = 'production'
	if globalSettings.globals.env
		env = globalSettings.globals.env 
	else
		NODE_ENV = process.env.NODE_ENV
		env = if NODE_ENV == 'production' or not NODE_ENV then 'production' else 'development'
		globalSettings.globals.env = env

	log.info 'Applying settings for environment "%s" based on NODE_ENV or globals.env', env
	_.assign globalSettings, settings[env]

	register null, settings: globalSettings