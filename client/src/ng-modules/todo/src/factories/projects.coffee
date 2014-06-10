do (module)->
  ###**
   * @ngdoc object
   * @name todo.factory:Projects
   *
   * @description
   * [description]
  ###
  module.factory 'Projects', di ($window)->
   
    all: ->
      projectJson = $window.localStorage['projects']

      if projectJson
        return angular.fromJson projectJson
      else
        return []
    save: (projects)->
      $window.localStorage['projects'] = angular.toJson projects

    newProject: (projectTitle)->
      title: projectTitle
      tasks: []

    removeProjects: ->
      delete $window.localStorage['projects']
      delete $window.localStorage['lastActiveProject']

    getLastActiveIndex: ->
       return parseInt($window.localStorage['lastActiveProject'], 10) or 0
       
    setLastActiveIndex: (index)->
      $window.localStorage['lastActiveProject'] = index
