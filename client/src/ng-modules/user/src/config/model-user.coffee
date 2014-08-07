do (module)->
  ###**
   * @ngdoc object
   * @name user.config:modelUser
   *
   * @description
   * [description]
  ###
  module.config di ($modelProvider)->

    $modelProvider.register 'User', di ($resource)->

      User = $resource '/api/0/users/:id', {id: '@id'},
        findById:
          url: '/api/0/users/:id'
          method: 'get'

      return User


    return