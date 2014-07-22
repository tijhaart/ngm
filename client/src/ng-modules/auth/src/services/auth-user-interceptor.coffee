do (module)->
  ###**
   * @ngdoc service
   * @name auth.service:AuthUserInterceptor
   *
   * @description
   * [description]
  ###
  module.service 'AuthUserInterceptor', di ($log, $q, $auth)->
    log = $log "#{module.name}:AuthUserInterceptor"

    @request = (req)->
      if token = $auth.token()
        req.headers.authorization = token

      return req

    return @