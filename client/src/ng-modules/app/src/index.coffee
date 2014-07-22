###**
 * @ngdoc object
 * @name app
 *
 * @description [description]
 *
###
module = do ( module = angular.module('app', ['session', 'auth', 'logger']) )->

  module.run di ($session, $log, $http)->
    log = $log "#{module.name}:run"
    session = $session.createSession()

    user =
      email:'johndoe@example.com'
      password: 'demo'

    session.$auth.login().then (user)->
      log.debug 'authenticated user', user
    , (res)->
      log.warn res

      session.$auth.login(user)
      .then (user)->
        log.debug 'user', user
      , (err)->
        log.error 'err', err

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
