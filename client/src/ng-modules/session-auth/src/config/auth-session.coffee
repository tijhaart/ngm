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

      User = $resource '/api/0/users', null,
        login:
          url: '/api/0/users/login'
          method: 'POST'
          params:
            include: 'user'
          interceptor:
            response: (res)-> res
        logout:
          url: '/api/0/users/logout'
          method: 'post'

      return User

    SessionProvider.plugin 'auth', di (Auth)-> Auth
    
    $provide.decorator 'AuthUserModel', di ($delegate)->
      allowed = ['$login', '$logout']

      _.forEach $delegate::, (value, method)->
        # console.log value, method
        delete $delegate.prototype[method] if not _.contains allowed, method

      return $delegate

    return