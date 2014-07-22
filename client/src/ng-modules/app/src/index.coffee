###**
 * @ngdoc object
 * @name app
 *
 * @description [description]
 *
###
module = do ( module = angular.module('app', ['session', 'auth', 'logger']) )->

  module.run di ($session, $log)->
    log = $log "#{module.name}:run"
    session = $session.createSession()

    user =
      email:'johndoe@example.com'
      password: 'demo'

    session.$auth.login(user)
      .then (user)->
        log.info 'user', user
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
