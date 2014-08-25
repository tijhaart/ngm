#!/usr/bin/env coffee

app = require 'commander'
exec = (require 'child_process').exec
util = require 'util'
$path = require 'path'

root = $path.resolve __dirname, '../'
__base = (path)-> root + path

app
  .version('0.0.1')

stdout = (err, stdout, stderr)->
  if not err
    util.puts stdout
    process.exit 0
  else
    util.puts err
    process.exit 1
  return

setup = __base '/test/setup'

app
  .command('test [file]')
  .description('Run mocha tests with project specific settings')
  .action((file, options)->
    file = file or './'
    exec "mocha --compilers coffee:coffee-script/register -R spec -r #{setup} #{file}", stdout
  )


app.parse(process.argv)