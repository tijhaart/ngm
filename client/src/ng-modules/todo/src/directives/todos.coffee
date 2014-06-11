do (module)->
  ###**
   * @ngdoc directive
   * @name todo.directive:todos
   * @element ANY
   *
   * @description
   * [description]
   *
   * @example
     <div todos></div>
  ###
  module.directive 'todos', di ()->
    restrict: 'A'
    controller: 'TodoCtrl'
    templateUrl: 'todo/todo-example.html'
    link: ($scope, $el, attrs, ctrl)->
      return