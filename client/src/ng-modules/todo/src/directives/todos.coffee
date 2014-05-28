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
    controller: di ($scope, TodoService)->
      $scope.Todo = Todo = TodoService 
      $scope.todos = TodoService.collection

      return 
    link: ($scope, $el, attrs, ctrl)->
      return