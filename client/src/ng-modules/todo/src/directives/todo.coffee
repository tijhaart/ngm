do (module)->
  ###**
   * @ngdoc directive
   * @name todo.directive:todo
   * @element ANY
   *
   * @description
   * [description]
   *
   * @example
     <div todo></div>
  ###
  module.directive 'todo', di ()->
    restrict: 'A'
    require: '^todos'
    controller: di ($scope)->
      return 
    link: ($scope, $el, attrs, ctrl)->
      return