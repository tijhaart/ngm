do (module)->
  ###**
   * @ngdoc object
   * @name todo.controller:TodoCtrl
   * @function
   *
   * @description
   * [description]
  ###
  module.controller 'TodoCtrl', di ($scope, todoProjectService, $ionicSideMenuDelegate)->
    $scope.TodoCtrl = @
    Todo = todoProjectService

    # create sample project with sample tasks
    do ->
      if not (_.where Todo.getProjects(), title: 'Groceries').length
        project = Todo.createProject 'Groceries'
        tasks = ['Milk', 'Bread', 'Peanutbutter', 'Jelly', 'Kitchen timer']
        project.$task.add tasks
        project.$save()
      return

    @projects = Todo.getProjects()

    @setActiveProject = (project, $index)=>
      console.log project, $index
      @activeProject = project
      Todo.setLastUsedProjectIndex $index

    @toggleProjects = ->
      $ionicSideMenuDelegate.toggleLeft()

    @saveProjects = (projects)-> Todo.saveProjects(projects)

    if index = Todo.getLastUsedProjectIndex()
      @setActiveProject @projects[index], index
    else 
      @setActiveProject @projects[0], 0

    return @