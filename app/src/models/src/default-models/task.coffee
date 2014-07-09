module.exports = (ModelHelper)->

  modelCfg =    
    name: 'task'
    properties:
      taskId:
        type: 'number'
        generated: true,
        id: true
      title:
        type: 'string'
        required: true
      complete: 'boolean'

  ModelHelper.register(modelCfg).then (data)->
    model = data.model



    return model


  return modelCfg