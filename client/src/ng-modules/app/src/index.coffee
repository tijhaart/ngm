###**
 * @ngdoc object
 * @name app
 *
 * @description [description]
 *
###
module = do ( module = angular.module('app', ['session', 'auth', 'ionic', 'util']) )->

  module.run di ($session, $log, $http, $rootScope, $location, $state, $stateChange, AUTH_ERR)->
    log = $log "#{module.name}:run"
    session = $session.createSession()
    $rootScope.$log = $log
    $rootScope.currentSession = session
    

    # service
    $stateChange
      .start (e, to, from)->
        log
          .ns 'stateChangeStart'
          .debug 'start', arguments
          .info to.state.name, to.state.url

        ###
        session.$auth.authorize(<to.state.acl>)
          .error (err)->
            e.preventDefault err
        ###
        # note: current session might have changed
        # session.$auth.authorize

        if to.state.data and to.state.data.acls
          log.debug to.state.data.acls

          ($rootScope.currentSession.$auth.authorize to.state.data.acls)
            .error (err)->
              log.error err

              if err.code == AUTH_ERR.NOT_AUTHENTICATED.code
                $state.go 'user-login'

              return

        else
          log.warn 'no data or data.acls defined'

        # reset namespace suffix for the logger
        log.ns null
        return

      .error (e, to, from, err)->
        log.error 'err', arguments
      .success (e, to, from)->
        log.debug 'success', arguments

    # e - event
    # to: state, params
    # from: state, params

    # user =
    #   email:'johndoe@example.com'
    #   password: 'demo'

    # session.$auth.on 'user.authenticated', (e, res)->
    #   user = res.user
    #   log.info "User '#{user.username}' is authenticated via #{res.accessType}"
    #   $state.go 'dashboard'

    #   res.session.user = user

    # session.$auth.on 'user.authFailed', (e, res)->
    #   $state.go 'user-login'
    #   console.log 'authFailed'

    # # try to restore previously remembered login by token
    # session.$auth.login()

    return


    # $rootScope.$on '$stateChangeStart', (e)->
    #   if not session.$auth.isLoggedIn() then $location.path '/app/login'


    # on login success, navigate to home/dashboard
    # on error, show error
    # on re-login/re-authenticate (from specific page) navigate to last know page


    # session.$auth.login().then (user)->
    #   log.debug 'authenticated user', user
    # , (res)->
    #   log.warn res

    #   session.$auth.login(user)
    #   .then (user)->
    #     log.debug 'user', user
    #   , (err)->
    #     log.error 'err', err

    ###
    session.$auth.login
      email: 'johndoe@example.com'
      password: 'demo'
    .then (res)->
      console.log 'app,$auth.login', res

      session.$auth.logout().then (res)->
        console.log 'session.$auth.logout()', res
    ###



  return module
