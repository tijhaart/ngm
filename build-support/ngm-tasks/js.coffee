path      = require 'path'
imports   = require '../gulp-imports'

coffee    = require 'gulp-coffee'
concat    = require 'gulp-concat'
wrap      = require 'gulp-wrap'

module.exports = (modules, gulp, gutil)->

  modules.task 'compile', 'coffee', (module, args, callback)->
    target = path.join module.path, '/**/*.coffee'

    task = (module)->
      target = path.join module.path, '/**/*.coffee'

      gulp.src target
        .pipe coffee( bare: true ) # sourceMpa = error because of macro
        # .pipe sweet modules: ['./build-support/macros/di'] # superslow. with it: ~750ms, without ~30ms, use only for production.min.js
        .pipe concat module.dirName + '.js'
        .pipe wrap ";(function(angular) { <%= contents %> } )(angular);"
        # .pipe gulpif isDev(), pretty()

    # module.watch target, 'compile.coffee.'+module.name, task

    if args.watch
      console.log 'watching: ', target
      gulp.watch target, (res)->
        gutil.log "[#{module.name}]", res.type, res.path
        console.log 're-run', 'compile.coffee.' + module.name
        task(module).pipe gulp.dest args.jsDest
        return

    return task(module).pipe gulp.dest args.jsDest

  return