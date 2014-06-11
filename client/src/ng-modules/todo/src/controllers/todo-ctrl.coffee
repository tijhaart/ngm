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

    $scope.newProjectModal = newProjectModal = {}

    $ionicModal.fromTemplateUrl 'todo/modal/new-project.html', (modal)->
      newProjectModal = modal
      return
    , 
      scope: $scope

    $scope.newProject = ->
      console.log 'calling newProject'
      # newProjectModal.show()
      
      return
    $scope.closeNewProject = ->
      newProjectModal.hide()
      return

    $scope.createProject = (project)->
      if project and project.title then createProject project.title
      newProjectModal.hide()
      return

    $scope.selectProject = (project, index)->
      $scope.activeProject = project
      Projects.setLastActiveIndex index
      $ionicSideMenuDelegate.toggleLeft false 

    $scope.removeProjects = ->
      Projects.removeProjects()
      $scope.projects = null
      $scope.activeProject = null

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

    # $scope.newProject()

    $timeout ->
      if $scope.projects.length is 0 then $scope.newProject()
      return

    return @