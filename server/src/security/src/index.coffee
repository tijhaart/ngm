module.exports =
	consumes: ['util.model']
	provides: ['security.models']

module.exports.setup = (options, imports, register)->
	Model = imports['util.model']

	accessToken = Model.createModel 
		name: 'accessToken'
		options:
		  base: 'AccessToken'
		  "base-url": 'access-tokens'
		  acls: [
		      accessType: '*'
		      permission: 'DENY'
		      principalType: 'ROLE'
		      principalId: '$everyone'
		    ,
		      permission: 'ALLOW'
		      principalType: 'ROLE'
		      principalId: '$everyone'
		      property: 'create'     
		  ]

	acl = Model.createModel
		name: 'acl'
		options:
		  base: 'ACL'
		public: false

	register null,
		'security.models': 
			acl: acl
			accessToken: accessToken
		'security.models.acl': acl
		'security.models.accessToken': accessToken