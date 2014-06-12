describe 'todo', ->
  Given -> 
    module 'todo'
    inject ($controller, $rootScope)->
      @scope = $rootScope.$new()
      @ctrl = $controller 'TodoCtrl', $scope: @scope
    return

  describe 'call newProject when there are no projects', ->

  	Then -> expect(@scope.projects.length).toEqual(0)

  return