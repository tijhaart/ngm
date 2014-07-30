do (module)->
  ###**
   * @ngdoc object
   * @name user.controller:UserLoginCtrl
   * @function
   *
   * @description
   * [description]
  ###
  module.controller 'UserLoginCtrl', di ($log, $scope, $session)->
    log = $log "#{module.name}:UserLoginCtrl"
    session = $session.getCurrSession()
    $scope['UserLoginCtrl'] = @

    $scope.credentials = @credentials =
      email: null
      password: null

    @credentials.email = 'johndoe@example.com'
    @credentials.password = 'demo'

    @login = (credentials)=>
      session.$auth.login credentials
      @credentials = {}



    return