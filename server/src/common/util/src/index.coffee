$lodash 	= require 'lodash'
$promise 	= require 'bluebird'
$path 		= require 'path'

module.exports =
	consumes: ['$hooki']
	provides: ['util']

module.exports.setup = (options, imports, register)->
	$hooki = imports['$hooki']
	filter = ($hooki.slave name: 'util').filter	

	register null,
		util:
			$hooki: $hooki
			lodash: $lodash
			promise: $promise
			path: $path
			log: (filter 'log', null) or -> throw '"util.log" not implemented. Use $hooki to attach a logger'