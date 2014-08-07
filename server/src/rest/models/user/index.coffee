module.exports =
	consumes: ['util.model']
	provides: ['rest.models.user']

module.exports.setup = (options, imports, register)->

	Model = imports['util.model']

	model = Model.createModel
		name: 'user'		
		base: 'User'
		relations:
		  accessTokens:
		    model: 'accessToken'
		    type: 'hasMany'
		    foreignKey: 'userId'
		options:
		  acls: [
		      accessType: '*'
		      permission: 'DENY'
		      principalType: 'ROLE'
		      principalId: '$everyone'
		  ]

	register null,
		"rest.models.user": model