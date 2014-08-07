_ 	= require 'lodash'

module.exports = 
	consumes: []
	provides: ['$config', '$config.get']

module.exports.setup = (options, imports, register)->
	configList = {}

	Config = (id)->
		@$configId = id
		return this

	Config:: =
		defaults: (obj)->			
			_.defaults this, obj
			return this


	register null,
		'$config': (id)->
			if config = configList[id] 
				return config
			else
				return new Config id
		'$config.get': (id)-> configList[id]