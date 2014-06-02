###**
 * @ngdoc object
 * @name foo
 *
 * @description [description]
 * 
###
module = do ( module = angular.module('foo', []) )-> 
	console.log module.name
	console.log module
	return module
