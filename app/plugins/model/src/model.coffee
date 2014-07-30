_         = require 'lodash'
loopback  = require 'loopback'
bluebird  = require 'bluebird'

module.exports = (options, imports, register)->

  ModelHelper = ->
    @$models = []
    return @

  ModelHelper:: =
    reset: -> @$models = []
    register: (modelCfg)->
      # todo? check if model name exists

      modelCreated = bluebird.pending()

      _.defaults modelCfg,
        name: null
        properties: {}
        options: {}
        dataSource: 'db'

      # console.log '[ModelHelper] register', modelCfg.name

      modelFactory = (app, modelsResolved)->
        # console.log '[ModelHelper] attach to (given) app'
        Model = app.model loopback.createModel modelCfg
        # when models resolved then resolve model with models
        modelsResolved.then (models)->
          modelCreated.resolve(model: Model, models: models)

      # console.log @

      @$models.push 
        name: modelCfg.name, 
        factory: modelFactory
        modelCreated: modelCreated.promise, 

      return modelCreated.promise



  register null,
    "plugin.model.helper": -> new ModelHelper()