do (module)->
  ###**
   * @ngdoc object
   * @name session.provider:Session
   *
   * @description
   * [description]
  ###
  module.provider 'Session', di ($provide, $injector)->
    collection = []

    ###**
     * Allow $filter like getting a service
     *
     * @example
     * theService = providerName(anIdFromTheCollectionArray)
     *
     * @return {Function} Gets a previously registered service
    ###
    @$get = ->

    plugins = []
    pluginFactories = []

    @plugin = (pluginName, factory)->
      plugins.push id:pluginName, factory:factory

      factoryId = 'SessionPlugin' + _.str.camelize(_.str.capitalize(pluginName))
      pluginFactories.push name: pluginName, factory: factoryId

      $provide.factory factoryId, factory

    $provide.factory '$storage', ($log)->
      $log = $log '$storage'

      Store = (opts)->
        _.defaults opts,
          key: null
        @key = opts.key
        return this

      Store:: =
        $clear: ->
          $log.info '$clear'
          _.forEach @, (val, property, store)->
            if store.hasOwnProperty property
              delete store[property]

          @$save()
        $restore: ->
          $log.info 'attempt to restore,', @key

          if value = localStorage[@key]
            value = angular.fromJson value
            _.assign this, value

            $log.info 'fetched from storage', this

          return this
        $save: ->
          if not _.isEmpty @
            $log.info 'store.$save', value = angular.toJson this
            localStorage[@key] = value
          else
            $log.info 'delete plugin storage', @key
            delete localStorage[@key] if localStorage[@key]

          return this


      return Store

    $provide.factory '$session', di ($injector, $log, $storage)->
      sessions = []
      currentSession = null

      setCurrentSession = (session)->
        currentSession = session

      addSession = (session)->
        if not sessions.length then setCurrentSession session
        sessions.push session
        return session

      Session = ->
        @_addPlugins @, pluginFactories
        return @

      decoratePlugin = (pluginName, factory)->
        # store and restore to/from localStorage
        factory.prototype.store = -> @store = new $storage
          key: "session.$#{pluginName}"

        return factory

      Session:: =
        _addPlugins: (session, plugins)->
          session = this
          _.forEach plugins, (plugin)->
            $plugin = decoratePlugin plugin.name, $injector.get plugin.factory
            session["$#{plugin.name}"] = new $plugin session
            return
          return

        isCurrentSession: ->

      getCurrSession: -> currentSession
      createSession: ->
        session = new Session arguments
        addSession session
        return session


    @register = (id, configFn)->
      # Register services like factories
      #
      # Example:
      # $provide.factory id, ($q)->
      #   collection[id] = (args)->
      #     invoked = $injector.invoke configFn
      #   return collection[id]
      #
      # module.config (thisProvider)->
      #   thisProvider.register <id>, configFn
      return

    return this