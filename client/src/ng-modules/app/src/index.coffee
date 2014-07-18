###**
 * @ngdoc object
 * @name app
 *
 * @description [description]
 * 
###
module = do ( module = angular.module('app', ['session', 'user']) )-> 
  
  module.run ($session, $injector)->
    session = $session.createSession()
    console.log session

    session.$auth.login
      username: 'john'
      password: 'demo'
    .then (res)->
      console.log '$auth.login', res


  return module
