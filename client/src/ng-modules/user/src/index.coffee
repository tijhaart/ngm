###**
 * @ngdoc object
 * @name user
 *
 * @description [description]
 * 
###
module = do ( module = angular.module('user', ['breeze.angular']) )-> 

  module.factory 'models', di ->

    collection = 
      user: {}

    #return
    (model)-> collection[model]


  module.run di (models)->
    User = models 'user'

  return module
