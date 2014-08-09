module.exports =
	consumes: []
	provides: [
		'settings.global',
		'settings.development',
		'settings.production'
	]

module.exports.setup = (options, imports, register)->

	register null,
		'settings.global': require __dirname + '/settings' or {}
		'settings.development': require __dirname + '/development.settings' or {}
		'settings.production': require __dirname + '/production.settings' or {}