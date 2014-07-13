###**
 * @ngdoc object
 * @name todo
 *
 * @description [description]
 * 
###
module = do ( module = angular.module('todo', ['ionic', 'gettext']) )-> 
  
  module.run di (gettextCatalog, $http, $timeout, $rootScope, $log)->

    $http.get('lang/nl_NL.json').then (res)->
      gettextCatalog.setStrings 'nl', res.data['nl']
      gettextCatalog.currentLanguage = 'nl'

    gettextCatalog.debug = false

    $rootScope.$log = -> $log.info.apply(this, arguments)

    return

  return module