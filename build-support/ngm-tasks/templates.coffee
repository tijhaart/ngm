path      = require 'path'

jade      = require 'gulp-jade'
ngtpl     = require 'gulp-angular-templatecache'


module.exports = (modules, gulp, gutil)->

  modules.task 'compile', 'jade', (module, args, callback)->
    target = (path.join module.path, '/templates/**/*.jade')

    task = (module)->
      gulp.src (path.join module.path, '/templates/**/*.jade')
        .pipe jade()
        .pipe ngtpl(
          filename: module.dirName + '.tpl.js'
          root: module.name
          module: module.name
        )

    if args.watch
      console.log 'watching: ', target
      gulp.watch (path.join module.path, '/templates/**/*.jade'), (res)->
        gutil.log "[#{module.name}]", res.type, res.path
        console.log 're-run', 'compile.jade.' + module.name
        task(module).pipe gulp.dest args.tplDest
        return

    return task(module).pipe gulp.dest args.tplDest

  return