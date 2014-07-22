do (module)->
  ###**
   * @ngdoc service
   * @name auth.service:$auth
   *
   * @description
   * [description]
  ###
  module.service '$auth', di ($session)->

    @token = (session)->
      session = session or $session.getCurrSession()
      return session.$auth.token()

    return this