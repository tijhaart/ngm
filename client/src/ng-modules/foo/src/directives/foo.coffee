do (module)->
  ###**
   * @ngdoc directive
   * @name foo.directive:foo
   * @element ANY
   *
   * @description
   * [description]
   *
   * @example
     <div foo></div>
  ###
  module.directive 'foo', di ()->
    restrict: 'A'
    controller: di ($scope)->
      return 
    link: ($scope, $el, attrs, ctrl)->
      return