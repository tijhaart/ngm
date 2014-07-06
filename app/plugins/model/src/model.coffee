_ = require 'lodash'

module.exports = (options, imports, register)->

  ModelHelper =
    $models: []
    register: (modelCfg)->
      console.log 'register', modelCfg.name
      _.defaults modelCfg,
        name: null
        properties: {}
        options: {}
        dataSource: 'db'

      @$models.push modelCfg

  register null,
    "plugin.model.helper": ModelHelper