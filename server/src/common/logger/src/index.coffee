log4js = require 'log4js'

module.exports =
	consumes: []
	provides: ["$log", "log"]
	hooki:
		'util.log': (log)->
			if not log
				log = log4js.getLogger()
			return log

module.exports.setup = (options, imports, register)->
	register null,
		$log: log4js.getLogger.bind log4js
		log: log4js.getLogger()