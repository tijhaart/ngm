loopback  = require 'loopback'
_         = require 'lodash'
Promise   = require('bluebird')
log       = (require 'log4js').getLogger 'models'

module.exports = (options, imports, register)->
  bus             = imports.bus
  ModelHelper     = imports['plugin.model.helper']()
  modelsAttached  = Promise.pending()


  defaultModels = ['project', 'task', 'user', 'accessToken', 'acl']

  models = _.map defaultModels, (modelName)-> 
    model = require("./default-models/#{modelName}")()    
    log.debug 'register model: ' + model.name
    # ModelHelper.register model
    return model

  ###*
   * Create and attach loopback models to the given (loopback/express) app
   * @param  {loopback app} app
   * @return {promise}      All models are attached
  ###
  attachModels = (app)->
    log.debug 'attach models'

    if ModelHelper.$models.length
      _.forEach ModelHelper.$models, (model)->
        model.factory app, modelsAttached.promise

      modelsAttached.resolve(app.models)
    else 
      # modelsAttached.reject message: 'No models'

    return modelsAttached.promise

  register null,
    model:
      models: models
      modelsAttached: modelsAttached.promise
      registerModel: -> ModelHelper.register.apply(ModelHelper, arguments)
      attachModels: attachModels
