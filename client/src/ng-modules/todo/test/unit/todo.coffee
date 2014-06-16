# projects
# - get projects

# project
# - create/update/delete/get/save project
# - attach tasks

# task
# - create/update/delete/get/save task

describe 'service: todoProjectService', ->

  # fixture
  fxt =
    project: 
      title: 'Eat supper'
    task:
      title: 'Get ingredients from store'

  # given project x
  # it should create a new task y 

  Given -> module 'todo'
  Given -> inject (_todoProjectService_)-> @service = _todoProjectService_

  describe 'create a new project', ->

    Given -> @projectTitle = fxt.project.title
    Given -> @project = @service.createProject @projectTitle

    Then -> expect(@project.title).toBe(@projectTitle)
    And -> expect(@project.$task.count()).toBe(0)

    describe 'add a new task to the project', ->
      task =
        title: fxt.task.title
        done: false

      Given -> @taskTitle = fxt.task.title
      Given -> @task = @project.$task.add(@taskTitle)
      Then -> expect(@task).toEqual(task)
      And -> expect(@project.$task.count()).toBe(1)

    

  


# describe 'todo', ->
#   Given -> 
#     module 'todo'
#     inject ($controller, $rootScope)->
#       @scope = $rootScope.$new()
#       @ctrl = $controller 'TodoCtrl', $scope: @scope
#     return

#   describe 'call newProject when there are no projects', ->

#   	Then -> expect(@scope.projects.length).toEqual(0)

#   return