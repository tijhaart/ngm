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
    @projects = Todo.projects
    
    demoProj = Todo.createProject 'Demo'
    demoProj.$task.add 'Test task'
    demoProj.$task.add 'Test task v2'


    @activeProject = @projects[Todo.getLastUsedProjectIndex()]

    @toggleProjects = ->
      $ionicSideMenuDelegate.toggleLeft()

    return @