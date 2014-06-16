do (module)->
  ###**
   * @ngdoc service
   * @name todo.service:todoProjectService
   *
   * @description
   * Create project and assign tasks
  ###  
  module.service 'todoProjectService', di ()->

    Task = (title)->
      add(title) if title
      @tasks = []
      return @

    Task:: =
      add: (title)->
        task =
          title: title
          done: false
        @tasks.push task
        return task
      # return all tasks
      all: -> @tasks
      count: -> @tasks.length
    
    @createProject = (title)->
      project =
        title: title
        $task: new Task()

      return project

    return this