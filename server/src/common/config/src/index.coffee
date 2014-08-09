_ 	= require 'lodash'

module.exports = 
	consumes: ['settings', '$log']
	provides: ['$config', '$config.get']

module.exports.setup = (options, imports, register)->
	settings = imports['settings']
	log = imports['$log'] 'config'

	log.setLevel 'error'

	delete settings['name'] # c9/architect residue

	configList = {}

	Config = (id)->
		@$configId = id
		return this

	Config:: =
		assign: (config)->
			_.assign this, config
			return this
		override: (config)->
			return if not config

			log.debug 'Assign globals for ', @$configId, config
			_.assign this, config

			return this
		defaults: (obj={})->			
			_.defaults this, obj

			@override settings[@$configId]

			return this

	configList['globals'] = new Config('globals').assign(settings['globals'] or {})

	register null,
		'$config': (id)->
			if config = configList[id] 
				return config
			else
				configList[id] = new Config id
				return configList[id]
		'$config.get': (id)-> configList[id]