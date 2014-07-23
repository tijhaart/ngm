do (module)->
  ###**
   * @ngdoc object
   * @name app.config:globalConfig
   *
   * @description
   * [description]
  ###
  module.config di ($locationProvider)->

    $locationProvider.html5Mode true

    return