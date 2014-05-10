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
    clientPath: PROJECT_PATH + '/.tmp/public'
    serverPort: 9000 || 1234
    projectPath: PROJECT_PATH
    database:
      'postgres':
        port: 1345
        host: 'postgres://192.168.1.924'

  register null, 
    config: config