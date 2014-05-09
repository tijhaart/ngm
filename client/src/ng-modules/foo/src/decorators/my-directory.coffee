do (module)->
  ###**
   * @ngdoc object
   * @name foo.decorator:myDirectory
   *
   * @description
   * [description]
  ###
  module.config di ($provide)->
    $provide.decorator 'myDirectory', di ($delegate)->
      return $delegate