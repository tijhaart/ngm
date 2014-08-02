module.exports = (options, imports, register)->

	emitter = new imports['plugin.event.emitter']
		wildcard: true
		delimiter: ':'
		maxListeners: 10

	register null,
		bus:
			emit: emitter.emit.bind emitter
			on: emitter.on.bind emitter
			off: emitter.off.bind emitter