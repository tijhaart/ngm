module.exports = (ModelHelper)->
  modelCfg =
    name:'user'
    base: 'User'

  ModelHelper.register modelCfg

  return modelCfg