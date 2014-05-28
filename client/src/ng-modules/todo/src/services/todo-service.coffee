do (module)->
  extend = angular.extend

  ###**
   * @ngdoc service
   * @name todo.service:TodoService
   *
   * @description
   * [description]
  ###  
  module.service 'TodoService', di ()->
    
    @collection = []

    @addTodo = (todo)=>
      todo = extend 
        title: null
        createdAt: new Date()
        done: false
      , todo

      @collection.push(todo)

      return todo

    @removeTodo = (index)=>
      @collection.splice index, 1


    @addTodo
      title: 'Create a new todo' 

    return this