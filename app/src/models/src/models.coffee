loopback  = require 'loopback'
_         = require 'lodash'
Q         = require('bluebird')

module.exports = (options, imports, register)->
  ModelHelper     = imports['plugin.model.helper']()
  modelsAttached  = Q.pending()

  # require('./default-models/project')(ModelHelper)

  defaultModels = ['project', 'task', 'user']

  _.forEach defaultModels, (modelName)-> 
    require("./default-models/#{modelName}")(ModelHelper)

  ###*
   * Create and attach loopback models to the given (loopback/express) app
   * @param  {loopback app} app
   * @return {promise}      All models are attached
  ###
  attachModels = (app)->

    _.forEach ModelHelper.$models, (model)->
      model.factory app, modelsAttached.promise

    modelsAttached.resolve(app.models)

    return modelsAttached.promise

  register null,
    models:
      modelsAttached: modelsAttached.promise
      registerModel: -> ModelHelper.register.apply(ModelHelper, arguments)
      attachModels: attachModels
