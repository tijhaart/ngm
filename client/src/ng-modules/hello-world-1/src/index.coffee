module = do ( module = angular.module('helloWorld', []) )->

  module.run ->
    console.log 'running ' + module.name

    console.log 'foo'


  return module