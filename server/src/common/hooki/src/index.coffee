_ = require 'lodash'

# max hooki's : 10 
# priority: 100
# 
Hooki =
	Master: (opts={})->
		@slaves = {}
		@hookies = {}

		_.defaults opts,
			name: null
			hookies: []

		ERR =
			INVALID_NAME: new Error "opts.name isn't set"

		throw ERR.INVALID_NAME if not opts.name

		@name = opts.name

		return this
	Slave: (opts={})->
		_.defaults opts,
			name: null

		ERR =
			INVALID_NAME: new Error "opts.name isn't set"

		throw ERR.INVALID_NAME if not opts.name

		@name = opts.name

		return this

Hooki.Master:: =
	slave: (slaveOpts={})->
		master 	= this
		slave 	= new Hooki.Slave slaveOpts
		filter 	= slave.filter 

		slave.filter = (key, value, opts={})=>

			# @todo limit amount of hookies/filters 
			hookies = _.map master.hookies["#{slave.name}.#{key}"], (hooki)-> hooki.filter

			console.log "hooki.slave(#{slave.name}).filter.#{key}", '# filters', hookies.length

			_.defaults opts,
				# clear all hookies for this key after filter was called
				clearHookies: false

			_value = filter.apply slave, [key, value, hookies, opts]

			if opts.clearHookies
				delete master.hookies["#{slave.name}.#{key}"]			

			return _value

		@slaves[slave.name] = slave

		return slave
	hook: (plugins)->
		# on plugin register get hookies?
		# on service check for hookies and apply them

		hookies = @hookies

		# extract hookies from each plugin and join them by key
		# @todo limit amount of hookies/filters 
		_.forEach plugins, (plugin)->
			if _hookies = plugin.hooki
				_.forEach _hookies, (hooki, index)->
					if not (_.isArray hookies[index]) then hookies[index] = []

					if _.isFunction hooki
						hookiFilterFn = hooki
						hooki =
							priority: 100
							filter: hookiFilterFn

					hookies[index].push hooki
					return
			return
		
		# sort hookies by priority
		_.forEach hookies, (hookie, index)->
			# sort hooki descending e.g [1,2,4] => [4,2,1] so the higher priority will be called last
			hookies[index] = _.sortBy hookies[index], (hooki)-> -hooki.priority

		return this

Hooki.Slave:: =
	# should call filter but should not modify the value
	# publish/export/config functions to register stuff
	# e.g. registerUser = export 'register.user', registerUserFn
	# 
	# hooki:
	# 	'x.register.user': (fn)->
	# 		fn name:'john', email:'jdoe@mail.com'
	config: ->
	filter: (key, value, filters, opts={})->
		value = _.reduce filters, (value, filter)-> 
			filter value
		, value
		return value

module.exports.Hooki = Hooki

# Exports for use as Architect plugin so plugins can create their own $hooki service
# like module.exports.architect does
module.exports =
	consumes: []
	provides: ['Hooki']
module.exports.setup = (options, imports, register)->
	register null,
		Hooki: Hooki

module.exports.architect = ->
	###*
	 * Collect hooki object from Architect plugins and inject '$hooki'
	 * @param  {Object[]} plugins List of resolved Architect plugins
	 * @return {Object[]} plugin list with $hooki Architect plugin added (so it can be used by Architect plugins e.g. imports['$hooki'])
	###
	return (plugins)->

		$hooki = new Hooki.Master name: '$hooki'
		$hooki.hook plugins

		plugins.push
			consumes: []
			provides: ['$hooki']
			packagePath: __dirname
			setup: (options, imports, register)->			
				register null, '$hooki': $hooki		

		return plugins
