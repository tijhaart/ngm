do (module)->
  ###**
   * @ngdoc object
   * @name todo.controller:TodoCtrl
   * @function
   *
   * @description
   * [description]
  ###
  module.controller 'TodoCtrl', di ($scope, $ionicModal, Projects, $timeout, $ionicSideMenuDelegate)->

    createProject = (projectTitle)->
      newProject = Projects.newProject projectTitle
      $scope.projects.push newProject
      Projects.save $scope.projects
      $scope.selectProject newProject, $scope.projects.length - 1
      return

    $scope.projects = Projects.all()
    $scope.activeProject = $scope.projects[Projects.getLastActiveIndex()]

    $scope.newProject = ->
      projectTitle = prompt 'Project title'

      if projectTitle then createProject projectTitle
      
      return

    $scope.selectProject = (project, index)->
      $scope.activeProject = project
      Projects.setLastActiveIndex index
      $ionicSideMenuDelegate.toggleLeft false 

    $scope.tasks = [
        title: 'Collect coins'
      ,
        title: 'Eat mushrooms'
      ,
        title: 'Get high enough to grab the flag'
      ,
        title: 'Find the mushrooms'
    ]

    $ionicModal.fromTemplateUrl 'todo/new-task.html', (modal)->
      $scope.taskModal = modal
      return
    ,
      scope: $scope

    $scope.createTask = (task)->
      if not $scope.activeProject or not task then return

      $scope.activeProject.tasks.push 
        title: task.title
      $scope.taskModal.hide()
      Projects.save $scope.projects
      task.title = null
      return

    $scope.newTask = ->
      $scope.taskModal.show()
      return

    $scope.closeNewTask = ->
      $scope.taskModal.hide()
      return

    $scope.toggleProjects = ->
      $ionicSideMenuDelegate.toggleLeft()

    $timeout ->
      if $scope.projects.length is 0
        loop
          projectTitle = prompt("Your first project title:")
          if projectTitle
            createProject projectTitle
            break
      return

    return @