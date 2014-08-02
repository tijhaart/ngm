emitter = (require 'eventemitter2').EventEmitter2

module.exports = (options, imports, register)->

	register null,
		"plugin.event.emitter": emitter