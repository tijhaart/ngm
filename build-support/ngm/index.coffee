_       = require 'lodash'
_str    = require 'underscore.string'
path    = require 'path'
glob    = require 'glob'
gulp    = require 'gulp'


###*
 * @todo setup watch method for default watching file changes inside a module
###

NGModule = (args)-> @main(args)

NGModule:: =
  main: (args)->
    _.defaults args,
      path: null

    @path = args.path
    @dirName = path.basename(@path.substr(0,@path.lastIndexOf '/src'))
    @name   = _str.camelize @dirName

    return @

module.exports.module = NGModule

module.exports.modules = (args)->
  _.defaults args,
    isDev: false
    src: null
  #return (glob.sync args.src).map (modulePath)-> new NGModule(path:modulePath)

  $tasks: {}
  modules: (glob.sync args.src).map (modulePath)-> new NGModule(path:modulePath)
  task: (group, name, fn)->
    self = this;

    @modules.forEach (module)=>
      taskId = "#{group}.#{name}.#{module.name}"
      
      if not @$tasks[group]
        @$tasks[group] = []

      @$tasks[group].push taskId
      
      console.log 'registered ', taskId

      gulp.task taskId, (cb)->
        return fn.apply(this, [module, args, cb])
