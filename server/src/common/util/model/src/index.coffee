lb = require 'loopback'

module.exports =
	consumes: []
	provides: ['util.model']

module.exports.setup = (options, imports, register)->

	register null,
		"util.model":
			createModel: (modelConfig)->
				lb.createModel modelConfig
			###*
			 * Attach model to loopback app
			 * @param  {loopback app} app - App created with loopback()
			 * @param  {Object} model - 
			 * @param  {Object} ds - Loopback dataSource (e.g. 'memory')
			 * @return {loopback app}
			###
			attachModel: (app, model, ds)->