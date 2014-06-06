do (module)->

  controller = di ($scope, TodoService)->
    $scope.Todo = Todo = TodoService 
    $scope.todos = TodoService.collection

    $scope.$watch 'todos.length', (count)->
      console.log 'There are now ' + count + ' todos'

    return 

  link = ($scope, $el, attrs, ctrl)->
    return

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
  module.directive 'todos', ->
    restrict: 'A'
    controller: controller
    link: link

  return