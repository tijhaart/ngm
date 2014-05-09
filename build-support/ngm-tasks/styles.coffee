path    = require 'path'

sass    = require 'gulp-sass'

module.exports = (modules, gulp, gutil)->
  modules.task 'compile', 'sass', (module, args, callback)->
    target = path.join module.path, 'styles/*.scss'

    task = (module)->
      target = path.join module.path, 'styles/*.scss'
      
      gulp.src target
        .pipe sass()

    if args.watch
      console.log 'watching: ', target
      gulp.watch target, (res)->
        gutil.log "[#{module.name}]", res.type, res.path
        console.log 're-run', 'compile.sass.' + module.name
        task(module).pipe gulp.dest args.cssDest
        return

    task(module).pipe gulp.dest args.cssDest