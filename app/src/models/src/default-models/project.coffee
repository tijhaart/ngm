module.exports = (ModelHelper)->
  modelCfg = 
    name: 'project' 
    properties:
      projectId:
        type: 'number' 
        id: true
        generated: true
      title:        
        type: 'string'
        required: true
      # description:  'string'
    dataSource: 'db'
    options:
      relations:
        task:
          model: 'task'
          type: 'hasMany'
          foreignKey: 'taskId'

  ModelHelper.register(modelCfg).then (data)->
    models = data.models
    model  = data.model

    projects = [
        title: 'Todo'
      ,
        title: 'Battlefield loadouts'
      ,
        title: 'Loopback'
    ]
    model.create projects, (err, res)->
      console.log err
      console.log res

    
    project = new model title: 'Foobar'

    project.task.create title: 'bar', (err, res)->
      console.log err, res

    project.save()


    return model

  return modelCfg