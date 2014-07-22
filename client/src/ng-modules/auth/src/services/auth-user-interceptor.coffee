do (module)->
  ###**
   * @ngdoc service
   * @name auth.service:AuthUserInterceptor
   *
   * @description
   * [description]
  ###  
  module.service 'AuthUserInterceptor', di ($q, $session)->
    
    @request = (req)->
      session = $session.getCurrSession()

      if token = session.$auth.token()
        req.headers.authorization = token

      return req

    return @