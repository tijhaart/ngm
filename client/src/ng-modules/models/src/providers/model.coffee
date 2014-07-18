do (module)->
  ###**
   * @ngdoc object
   * @name models.provider:$model
   *
   * @description
   * [description]
  ###
  module.provider '$model', di ($provide)->
    modelSuffix = 'Model'
    getModelId = (modelName)-> "#{_.str.camelize modelName}#{modelSuffix}"

    ###**
     * Allow $filter like getting a service
     *
     * @example
     * theService = providerName(anIdFromTheCollectionArray)
     * 
     * @return {Function} Gets a previously registered service
    ###
    @$get = di ($injector)-> 
      return (id)-> 
        modelId = getModelId id        
        $injector.get modelId

    @register = (id, factory)->
      modelId = getModelId id
      $provide.factory modelId, factory

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