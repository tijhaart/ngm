# bootstrap Angular app
angular.element(document).ready ->
  angular.bootstrap(document, ['ngm', 'app']);

  console.log 'hello world'