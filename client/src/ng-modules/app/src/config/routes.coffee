do (module)->
  ###**
   * @ngdoc object
   * @name app.config:routes
   *
   * @description
   * [description]
  ###
  module.config di ($stateProvider, $urlRouterProvider)->

    $urlRouterProvider
      .when('/app/', '/app')
      .otherwise('/app/page-not-found')

    app =
      base: '/app'
      url: (path)-> "#{this.base}#{path}"

    $stateProvider
      .state(
        name: 'dashboard'
        url: app.base
        templateUrl: 'app/dashboard/dashboard.html'
        data:
          acls: [
            { 
              accessType: '*'
              permission: 'ALLOW'
              principalType: 'Role'
              principalId: '$everyone' 
            }
          ]
      )
      .state(
        name: 'user-login'
        url: app.url '/login'
        templateUrl: 'app/user/login.html'
        controller: 'UserLoginCtrl'
      )
      .state(
        name: '404'
        url: app.url '/page-not-found'
        templateUrl: 'app/err/404.html'
      )

    return