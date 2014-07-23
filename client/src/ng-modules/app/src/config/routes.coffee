do (module)->
  ###**
   * @ngdoc object
   * @name app.config:routes
   *
   * @description
   * [description]
  ###
  module.config di ($stateProvider, $urlRouterProvider)->

    app =
      base: '/app'
      url: (path)-> "#{this.base}#{path}"

    $stateProvider
      .state(
        name: 'user-login'
        url: app.url '/login'
        templateUrl: 'app/user/login.html'
        controller: 'UserLoginCtrl'
      )

    return