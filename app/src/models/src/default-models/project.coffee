module.exports = (ModelHelper, attached)->
  modelCfg = 
    name: 'project' 
    properties:
      # id:           type: 'number', required: true, id: true
      title:        
        type: 'string'
        required: true
      # description:  'string'
    dataSource: 'db'

  projects = [
      title: 'Todo'
    ,
      title: 'Battlefield loadouts'
    ,
      title: 'Loopback'
  ]

  # todo make promise
  # when model is added it should be able to add some data
  ModelHelper.register(modelCfg)

  # attached.then (app)->
  # app.models.project.create projects