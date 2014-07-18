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
      console.log 'session.current', session = $session.getCurrSession()

      if token = session.$auth.token()
        req.headers.authorization = token
      

      console.log 'AuthUserInterceptor.request', req

      return req

    return @