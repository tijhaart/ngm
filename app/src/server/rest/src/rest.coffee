loopback = require 'loopback'
lbBoot   = require 'loopback-boot'

module.exports = (options, imports, register)->
  # server = imports.server.instance
  rest  = loopback()
  # Project.attachTo ds

  lbBoot rest, __dirname

  projects = [
      title: 'Aimms'
    ,
      title: 'Battlefield loadouts'
    ,
      title: 'Loopback'
  ]

  # Project = loopback.createModel 'project', ProjectSchema

  ProjectSchema = 
    name: 'project' 
    properties:
      # id:           type: 'number', required: true, id: true
      title:        
        type: 'string'
        required: true
      # description:  'string'
    dataSource: 'db'

  rest.model 'project', ProjectSchema

  rest.use loopback.rest()

  rest.models.project.create projects, (err, res)->
    console.log 'err', err
    console.log 'res', res

  register null,
    rest:
      instance: rest