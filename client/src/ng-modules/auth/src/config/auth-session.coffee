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

    SessionProvider.plugin 'auth', di ($q, $model, $log, $timeout)->
      log = $log "#{module.name}:session.$auth"
      AuthUser = $model 'AuthUser'
      User = $model 'User'

      console.dir User

      Auth = (session)->
        _log = $log "#{module.name}:Auth"
        self = @
        # setup storage support
        @store().$restore()

        log.debug 'restored ', @store

        authenticated = @store.authenticated

        @token = authenticated and authenticated.token or null
        @user = null
        @session = -> session

        token: -> self.token
        login: @login.bind self
        logout: -> $q.when true

      Auth:: =
        login: (credentials={}, settings={})->
          log.info 'login request', credentials, settings
          login = $q.defer()
          self = @

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

            $timeout ->
              log.debug 'moment'
            , 10000

            (User.findById id: authenticated.userId).$promise
            # success
            .then (user)->
              log.debug 'User.findById', user
              login.resolve user
            # error
            , (res)->
              log.error 'User.findById', arguments
              delete store['authenticated']
              store.$save()

              login.reject res.data.error

          else if (credentials.email or credentials.username) and credentials.password

            AuthUser.login credentials
            # save login data for further requests
            .$promise.then (res)->
              log.info 'login success', userId:res.data.userId
              store = self.store
              token = res.data.id
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

              return user
          else
            log.warn 'invalid credentials'
            login.reject
              msg: 'credentials missing'

          return login.promise
        logout: ->
        onLoginSuccess: ->
        onLoginErr: ->
        onLogoutSuccess: ->
        onLogoutErr: ->

      return Auth

      ###
      return (session)->

        console.log session.$auth

        user = null
        token = null

        state =
          isLoggedIn: null
          isLoginInProgress: null

        # @todo restore authentication if accessToken was saved to session or localStorage

        onLogoutSuccess = (res)->
          $log.info 'onLogoutSuccess', arguments

          response =
            userId: user.id

          user = null
          token = null

          return response

        onLogoutErr = (res)->
          $log.info 'onLogoutErr', arguments
          return

        token: -> token
        login: (credentials={}, settings={})->
          _.defaults credentials,
            email: null
            password: null

          _.defaults settings,
            remember: null

          AuthUser.login credentials
          # save login data for further requests
          .$promise.then (res)->
            token = res.data.id
            # use User model instead of AuthUser
            user = new AuthUser res.data.user

            # @todo: save token to storage if settins.remember = true
            console.log res.config.params.rememberMe != false



            return user
        # rest user and token
        logout: ->
          $log.info 'session.$auth', 'request logout',
            user: user,
            token: token
          if user
            return AuthUser.logout().$promise.then onLogoutSuccess, onLogoutErr
      ###

    $provide.decorator 'AuthUserModel', di ($delegate)->
      allowed = ['$login', '$logout']

      _.forEach $delegate::, (value, method)->
        # console.log value, method
        delete $delegate.prototype[method] if not _.contains allowed, method

      return $delegate

    return