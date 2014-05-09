###**
 * @ngdoc object
 * @name app
 *
 * @description [description]
 * 
###
module = do ( module = angular.module('app', []) )->
  module.value 'appMeta', {
    version: '0.0.1'
    author: 'R.Tijhaar'
    license: 'MIT'
  }

  module.run di (appMeta)->
    console.log appMeta.version
