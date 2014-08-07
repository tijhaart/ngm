log4js = require 'log4js'

module.exports =
	consumes: []
	provides: ["$log", "log"]

module.exports.setup = (options, imports, register)->
	register null,
		$log: log4js.getLogger.bind log4js
		log: log4js.getLogger()