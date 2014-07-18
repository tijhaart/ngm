do (module)->
  ###**
   * @ngdoc object
   * @name auth.config:session
   *
   * @description
   * [description]
  ###
  module.config di (SessionProvider, $modelProvider, $provide, $httpProvider)->

    $httpProvider.interceptors.push 'AuthUserInterceptor'

    $modelProvider.register 'AuthUser', di ($resource)->

      User = $resource '/api/v0/users', null,
        login:
          url: '/api/v0/users/login'
          method: 'POST'
          params:
            include: 'user'
          interceptor:
            response: (res)-> res
        logout:
          url: '/api/v0/users/logout'
          method: 'post'

      return User

    SessionProvider.plugin 'auth', di ($q, $model, $timeout)->
      AuthUser = $model 'AuthUser'

      return (session)->
        user = null
        token = null

        state = 
          isLoggedIn: null
          isLoginInProgress: null

        token: -> token
        login: (credentials, settings)->

          AuthUser.login
            email: 'johndoe@example.com'
            password: 'demo'
          # save login data for further requests
          .$promise.then (res)->
            console.log res
            console.log 'login.sucess', res.data
            token = res.data.id
            # use User model instead of AuthUser
            user = new AuthUser res.data.user

            # todo save token to storage

            return user
        # rest user and token
        logout: ->
          if user
            token = null
            AuthUser.logout()
          

    $provide.decorator 'AuthUserModel', di ($delegate)->
      allowed = ['$login', '$logout']

      _.forEach $delegate::, (value, method)->
        # console.log value, method
        delete $delegate.prototype[method] if not _.contains allowed, method

      return $delegate

    return