module.exports = (helper)->

  modelCfg =
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

  helper.register modelCfg

  return modelCfg