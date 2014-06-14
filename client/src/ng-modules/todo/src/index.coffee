###**
 * @ngdoc object
 * @name todo
 *
 * @description [description]
 * 
###
module = do ( module = angular.module('todo', ['ionic', 'gettext']) )-> 
  
  module.run di (gettextCatalog, $http, $timeout)->

    $http.get('lang/nl_NL.json').then (res)->
      gettextCatalog.setStrings 'nl', res.data['nl']
      gettextCatalog.currentLanguage = 'nl'

    gettextCatalog.debug = true

    return

  return module