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
    tasks: ['Foo','Bar','Foobar','Barfoo']

  Given -> module 'todo'
  Given -> inject (todoProjectService)-> @service = todoProjectService
  
  afterEach -> inject ($window)->
    @service.projects = [] 
    delete $window.localStorage['projects']
    delete $window.localStorage['projects.cfg.lastUsedProject']

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

      describe "save project", ->
        Given -> inject ($window)-> 
          @Storage = $window.localStorage
          return
        When -> 
          @project.$save()          
          @projects = angular.fromJson @Storage['projects']
        Then "it should have saved the project to a data store", -> 
          expect(@projects.length).toBe(1)
          expect(@projects[0].title).toBe(@projectTitle)

        describe "request last used project index before save", ->
          When -> @service.getLastUsedProjectIndex()
          Then -> @Storage['projects.cfg.lastUsedProject'] == undefined

        describe "set/get index of the last used project", ->
          When -> @service.setLastUsedProjectIndex(1)
          Then -> @service.getLastUsedProjectIndex() == 1
          And -> expect(parseInt(@Storage['projects.cfg.lastUsedProject'],10)).toBe(1)

        describe "get saved projects", ->
          When -> @projects = @service.getProjects()
          Then -> expect(@projects.length).toBe(1)

        describe "remove projects", ->
          When -> @service.removeProjects()
          Then -> expect(@service.getProjects()).toEqual([])


    describe 'add multiple tasks to the project', ->
      Given -> @tasks = fxt.tasks
      When ->
        _.forEach @tasks, (task)=>
          @project.$task.add task
          return
        return
      Then -> @project.$task.count() == 4
      # _.pluck joins only the task title in an array
      And -> expect(_.pluck @project.$task.all(), 'title').toEqual(@tasks)


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