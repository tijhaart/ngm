do (module)->
  ###**
   * @ngdoc object
   * @name foo.provider:myProvider
   *
   * @description
   * [description]
  ###
  module.provider 'myProvider', di ($provide, $injector)->
    collection = []
    a = 'b'

    ###**
     * Allow $filter like getting a service
     *
     * @example
     * theService = providerName(anIdFromTheCollectionArray)
     * 
     * @return {Function} Gets a previously registered service
    ###
    @$get = -> 
      return (id)-> collection[id]

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