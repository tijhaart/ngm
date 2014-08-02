module.exports = ->
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