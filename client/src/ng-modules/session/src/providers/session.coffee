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
      console.log 'get'
      return (id)-> collection[id]

    plugins = []
    pluginFactories = []

    @plugin = (pluginName, factory)->
      console.log 'Session.plugin', arguments
      plugins.push id:pluginName, factory:factory
      
      factoryId = 'SessionPlugin' + _.str.camelize(_.str.capitalize(pluginName))
      pluginFactories.push name: pluginName, factory: factoryId
      
      $provide.factory factoryId, factory


    $provide.factory '$session', di ($injector)->
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

      Session:: =
        _addPlugins: (session, plugins)->
          _.forEach plugins, (plugin)->
            session["$#{plugin.name}"] = $injector.get(plugin.factory)(@)
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