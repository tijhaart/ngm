loopback  = require 'loopback'
_         = require 'lodash'

module.exports = (options, imports, register)->
  ModelHelper = imports['plugin.model.helper']

  # rest.model loopback.createModel ProjectSchema
  # rest.models.project.create projects

  require('./default-models/project')(ModelHelper);

  attachModels = (app)->

    ModelHelper.$models.forEach (modelCfg)->
      console.log 'each', modelCfg.name
      app.model loopback.createModel modelCfg

    # rest.models.project.create projects

    # todo: resolve a promise
    # this promise should also be passed to any registerd models (cfg)
    # for example: added data when the model is created by loopback


  register null,
    models:
      registerModel: ModelHelper.register
      attachModels: attachModels
