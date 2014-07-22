do (module)->
  ###**
   * @ngdoc constant
   * @name logger.constant:LOG_LEVELS
   *
   * @description
   * [description]
  ###
  module.constant 'LOG_LEVELS',
    log: 0
    info: 1
    warn: 2
    debug: 3
    error: 4
    all: 5
    none: 6

  module.value 'LogConfig',
    disableLoggers: [
      {
        namespace: '*'
        levels: ['all']
      },
      {
        namespace: 'someapp:*'
        levels: ['all']
      },
      {
        namespace: 'auth:*'
        levels: ['log', 'info']
      }
    ]

  ###**
   * @ngdoc object
   * @name logger.decorator:$log
   *
   * @description
   * [description]
  ###
  module.config di ($provide)->
    $provide.decorator '$log', di ($delegate, LogConfig, LOG_LEVELS)->

      #console.log LogConfig, LOG_LEVELS

      origin = $delegate

      Log = (namespace)->
        @namespace = namespace or ''
        return this

      Log.prototype = {}

      loggers = []
      Log.addLogger = (log)->
        #console.log 'addLogger:',log.namespace
        loggers.push log
      Log.getLogger = (namespace)->
        result = _.where loggers, {namespace: namespace}
        if result.length
          return result[0]
        return undefined
      Log.canLog = (namespace, method)->

        # when one of the patterns match the namespace
        # and the method doesn't match the levels
        # then ignore the "match all namespaces pattern *""
        # and let the log method execute

        patterns = _.pluck LogConfig.disableLoggers, 'namespace'
        allowed = []

        matches = _.filter patterns, (pattern, index)->
          levels = LogConfig.disableLoggers[index].levels
          matched = false
          regex = null

          # match all namespaces
          if pattern != '*'
            regex = new RegExp "^#{pattern.replace(/:\*/g, ':.*')}", 'gi'
          else
            regex = new RegExp ".*", 'gi'

          if pattern != '*' and ( (regex.test namespace) or (namespace == pattern) )
            matched = (_.contains levels, 'all') or (_.contains levels, method)
            if not matched
              allowed.push method

          else if regex.test namespace or (namespace == pattern)
            matched = (_.contains levels, 'all') or (_.contains levels, method)
            if not matched
              allowed.push ns: namespace, method: method, pattern: pattern

          # no match found
          return matched

        if _.contains allowed, method
          isDisabled = false
        else if matches.length > 0
          isDisabled = true

        isEnabled = not isDisabled
        #console.log enabled: isEnabled, disabled: isDisabled, namespace: namespace, method: method, matches: matches
        return isEnabled


      _.forEach $delegate, (method, methodName)->
        #console.log 'decorate method:', methodName
        Log.prototype[methodName] = ->
          args = Array.prototype.slice.call arguments

          if Log.canLog @namespace, methodName
            colors =
              log: 'blue'
              info: 'teal'
              warn: 'yellow'
              debug: 'purple'
              error: 'red'
            textColor = if methodName != 'warn' then '#fff' else '#000'

            prefix = [
              "%c#{methodName}",
              "background:#{colors[methodName]}; color:#{textColor}; padding:2px; font-size: 0.8em;",
              "[#{@namespace}]",
            ]

            args = prefix.concat args
            method.apply this, args

      ns = (namespace)->
        log = Log.getLogger namespace

        if not log
          log = new Log namespace
          Log.addLogger log
        return log

      # @TODO: write tests for the $log decorator
      # log = ns('someapp:service')
      # log.log 'hello world'
      # log.info 'hello world'
      # log.warn 'hello world'
      # log.debug 'hello world'
      # log.error 'hello world'

      # fromLoggers = ns('someapp:messages')
      # fromLoggers.info 'hello precious world'


      # allow default $log behaviour
      # example: ns.info is the same as $log.info
      _.assign ns, $delegate

      return ns