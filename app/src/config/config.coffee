path    = require 'path'

module.exports = (options, imports, register)->

  PROJECT_PATH = path.resolve __dirname, '../../../'

  ###*
   * @todo make the config a getter/setter
   * @example
   * config('item') 
   * or
   * config('item', foo:'bar')
  ###

  config =
    routes: imports["config.routes"]
    clientPath: PROJECT_PATH + '/dist/public'
    serverPort: 9000 || 1234
    projectPath: PROJECT_PATH

  register null, 
    config: config