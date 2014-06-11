describe 'todo', ->
  Given -> 
    module 'todo'
    inject ($controller, $rootScope)->
      @scope = $rootScope.$new()
      @ctrl = $controller 'TodoCtrl', $scope: @scope
    return

  describe 'call newProject when there are no projects', ->
    Given ->      
      spyOn @scope, 'newProject'
      return
    # When -> @scope.projects.length == 0
    Then -> expect(@scope.newProject).toHaveBeenCalled()

    return

  return