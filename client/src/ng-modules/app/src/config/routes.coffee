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

    return