do (module)->

  # use sweet.js macro stuff
  module.controller 'uiDialogFooCtrl', di ($scope, $http)->
    @users = []

    $http.get '/users', (res)=>
      @users = res.data.users

    return @

  return