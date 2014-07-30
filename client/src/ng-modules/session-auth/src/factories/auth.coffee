do (module)->

  module.constant 'AUTH_ERR', 
    NOT_AUTHENTICATED:
      code: 403
      status: 'not authenticated'
      message: 'login is required'
    UNAUTHORIZED:
      code: 401
      status: 'unauthorized'
      message: "unsufficient access rights"
    TOKEN_EXPIRED:
      code: 489
      status: 'token expired'
      message: 'access token has expired'

  ###**
   * @ngdoc object
   * @name sessionAuth.factory:Auth
   *
   * @description
   * [description]
  ###
  module.factory 'Auth', di ($q, $model, $log, $timeout, $rootScope, AUTH_ERR)->
    log = $log "Auth"
    AuthUser = $model 'AuthUser'
    User = $model 'User'

    $on = $rootScope.$on.bind $rootScope
    $broadcast = $rootScope.$broadcast.bind $rootScope

    Auth = (session)->
      self = @
      # setup storage support
      @store().$restore()

      # houses flags
      @is = 
        authenticated: null
        authorized: null
        loggedIn: null

      log.debug 'restored ', @store

      authenticated = @store.authenticated

      @token = if (authenticated and authenticated.token) then authenticated.token else null
      @user = null
      @session = -> session

      token: -> self.token
      authorize: @authorize.bind self
      login: @login.bind self
      logout: @logout.bind self
      isLoggedIn: -> !!self.is.loggedIn
      on: (name, cb)->
        name = "$auth.#{name}"          
        log.info 'registered listener:', name
        $on name, cb
        return self

    Auth:: =
      authorize: (acls)->        
        log.ns 'authorize'
        acls = [acls] if _.isPlainObject acls
        defer = $q.defer()

        log.debug acls

        defer.reject AUTH_ERR.NOT_AUTHENTICATED
        
        log.ns null
        
        error: (callback)-> 
          defer.promise.then null, callback
        success: (callback)->
          defer.promise.then callback
        promise: defer.promise

      login: (credentials={}, settings={})->
        log.info 'login request', credentials, settings
        login = $q.defer()
        self = @
        session = self.session()

        _.defaults credentials,
          username: null
          email: null
          password: null

        _.defaults settings,
          remember: null

        log.warn 'settings.remember is not used'

        store = self.store
        authenticated = store.authenticated


        if authenticated and authenticated.token
          # note: token can be remote by server and the token might be invalid
          # so an interceptor might be of use here to remove the token an direct
          # to the login section

          log.debug 'authenticated', authenticated

          (User.findById id: authenticated.userId).$promise
          # success
          .then (user)->
            log.debug 'User.findById', user
            login.resolve user

            self.is.loggedIn = true
            # self.$broadcast 'user.authenticated', user: user, session: session, accessType: 'token'
          # error
          , (res)->
            log.error 'User.findById', arguments
            delete store['authenticated']
            store.$save()

            login.reject res.data.error
            self.is.loggedIn = false

        else if (credentials.email or credentials.username) and credentials.password

          AuthUser.login credentials
          # save login data for further requests
          .$promise.then (res)->
            log.info 'login success', userId:res.data.userId
            store = self.store
            token = res.data.id
            self.is.loggedIn = true
            # use User model instead of AuthUser
            user = new AuthUser res.data.user

            store.authenticated =
              userId: user.id
              token: token

            # @todo: save token to storage if settins.remember = true
            rememberMe = res.config.params.rememberMe != false
            log.info 'rememberMe', rememberMe
            if rememberMe
              store.$save()

            login.resolve user
            self.$broadcast 'user.authenticated', user: user, session: session, accessType: 'credentials'
            return user
          , onLoginErr = (res)->              
            log.warn 'Invalid credentials'
            self.is.loggedIn = false

            login.reject
              msg: 'credentials missing'
        else            
          log.warn 'Token based login failed'
          self.is.loggedIn = false
          login.reject
            msg: 'Token or credentials missing'

          # $on 'user.authFailed', (res)->
          #   console.log res

          # self.$broadcast 'user.authFailed', msg: 'Token or credentials missing', session: session

        login.promise.then null, (err)->
          log.error err

        return login.promise
      logout: ->
        AuthUser.logout().$promise.then (res)->
          console.log arguments
        , onLogoutErr = (res)->
          log.error res
      
      $broadcast: (name, args)->
        log.info '$broadcast', name:name, args:args
        name = "$auth.#{name}"
        $broadcast(name, args)
        return this

    return Auth