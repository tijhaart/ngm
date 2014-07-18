###**
 * @ngdoc object
 * @name models
 *
 * @description [description]
 * 
###
module = do ( module = angular.module('models', ['ngResource']) )-> 

  module.factory 'rtModelFactory', ($resource)->
    models = {}   
    
    User = $resource '/api/v0/users/:id', {id: '@id'}
    
    models['user'] = User

    getModel: (modelName)-> models[modelName]


  return module
