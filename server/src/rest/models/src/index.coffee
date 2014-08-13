module.exports =
	consumes: [
		'rest.models.user',
		'security.models'
	]
	provides: ['rest.models']

module.exports.setup = (options, imports, register)->

	register null,
		'rest.models': 
			user: imports['rest.models.user']
			accessToken: imports['security.models'].accessToken
			acl: imports['security.models'].acl