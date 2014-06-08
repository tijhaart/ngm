###**
 * @ngdoc object
 * @name foo
 *
 * @description [description]
 * 
###
module = do ( module = angular.module('nested', []) )-> 
  console.log module.name
  return module