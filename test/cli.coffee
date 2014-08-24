#!/usr/bin/env coffee

app = require 'commander'
exec = (require 'child_process').exec
sys = require 'sys'

app
  .version('0.0.1')
  .option('-f, --file [test]', 'Test [./]', './')

stdout = (err, stdout, stderr)->
  if not err
    sys.puts stdout
    process.exit 0
  else
    sys.puts err
    process.exit 1
  return
app
  .command('test')
  .action((cmd, options)->
    exec 'mocha --compilers coffee:coffee-script/register -R spec -r test/setup test/example.test.coffee', stdout
  )


app.parse(process.argv)