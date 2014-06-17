do (module)->
  ###**
   * @ngdoc service
   * @name todo.service:todoProjectService
   *
   * @description
   * Create project and assign tasks
  ###  
  module.service 'todoProjectService', di ($window)->

    @projects = []

    @saveProjects = (projects)->
      return

    Store = (key, value)->
      if not value 
        return if $window.localStorage[key] then angular.fromJson $window.localStorage[key]
      else
        return $window.localStorage[key] = JSON.stringify(value)
      return

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

    @getProjects = -> Store('projects') or []
    
    @createProject = (title)=>
      project =
        title: title
        $task: new Task()
        $save: => Store 'projects', @projects 

      @projects.push project

      return project

    return this