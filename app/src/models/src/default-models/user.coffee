module.exports = (ModelHelper)->
  modelCfg =
    name:'user'
    base: 'User'

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