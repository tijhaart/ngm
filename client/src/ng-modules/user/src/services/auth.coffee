do (module)->
  ###**
   * @ngdoc service
   * @name user.service:auth
   *
   * @description
   * [description]
  ###  
  module.service 'auth', di ()->
    @fn = -> return 'fn'

    return this