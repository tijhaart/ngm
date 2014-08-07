$lodash 	= require 'lodash'
$promise 	= require 'bluebird'
$path 		= require 'path'

module.exports =
	consumes: []
	provides: ['util']

module.exports.setup = (options, imports, register)->

	register null,
		util:
			lodash: $lodash
			promise: $promise
			path: $path