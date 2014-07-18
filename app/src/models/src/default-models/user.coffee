module.exports = (ModelHelper)->
  modelCfg =
    name:'user'
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

  ModelHelper.register(modelCfg).then (data)->
    model = data.model

    users = [
      username: 'johndoe'
      email: 'johndoe@example.com'
      password: 'demo'
    ,
      username: 'janedoe'
      email: 'janedoe@example.com'
      password: 'demo'
    ]

    model.create users
    , done = ->
      console.log arguments


  return modelCfg