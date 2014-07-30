###**
 * @ngdoc object
 * @name user
 *
 * @description [description]
 *
###
module = do ( module = angular.module('user', ['models', 'session', 'auth']) )->
  return module

  tokenId = null

  module.config ($httpProvider)->
    $httpProvider.interceptors.push 'loopbackRequestInterceptorAuth'

  module.factory 'loopbackRequestInterceptorAuth', di ($q)->
    request: (config)->

      console.log 'interceptor', config, tokenId

      if tokenId
        config.headers.authorization = tokenId

      console.log 'config', config

      return config

  module.factory '$session', di ->
    list = []

    Session = -> @init.apply @, arguments

    Session:: =
      init: -> console.log 'init new session', arguments
      restore: -> console.log 'restore session'
      save: -> console.log 'session.save', arguments
      get: -> return

    plugin: ->
    currentSession: ->

  module.factory 'models', di ($resource)->

    session =
      user: null
      auth:
        token: null

    sessionPlugins = []

    sessionPlugins.push
      auth:
        store: (opts)->
          console.log 'session.auth', arguments, this

          _.defaults opts,
            remember: null
            token: null

          # @save 'auth', token: opts.token

          return
        isAuthenticated: ->

    sessionPlugins.push
      user: (user)->
        # @_user should be stored elsewhere instead of directly on the session instance
        if not _.isUndefined user
          @_user = user
        else if @_user
          return @_user
        else
          console.log 'session.$user', 'user not set'
          return null

    # _.forEach sessionPlugins, (plugin)->
    #   key = (Object.keys plugin)[0]
    #   pluginMethodId = "$#{key}"
    #   Session.prototype[pluginMethodId] = plugin[key]

    # mock loopback service

    loopback =
      requestInterceptor: (name)->
        interceptors =
          'auth.logout': (res)->
            console.log 'request', 'auth.logout', arguments
            return

        return -> interceptors[name]
      responseInterceptor: (name)->
        interceptors =
          'auth.logout': (res)->
            console.log 'user.logout', res
            # session.auth.reset()
            return

          'auth.login': (res)->
            console.log 'user.login', res
            token = res.resource

            # session.$auth.store
            #   remember: false
            #   token: token.id

            # tmp
            session.auth.token = token.id

            tokenId = token.id

            user = new User res.data.user

            # logout
            # session.auth.reset()

            # logout but remember login

            #return
            accessToken: res.resource
            user: user


        return ->
          return interceptors[name]

    api =
      root: '/api/v0'
      url: (uri)-> @root + uri

    resource =
      root: api.url '/users'
      url: (uri)-> api.url.apply this, arguments

    User = $resource (resource.url '/:id'), {id: '@id'},
      logout:
        url: resource.url '/logout'
        method: 'post'
        interceptor:
          response: loopback.responseInterceptor('auth.logout')()
          # request: loopback.requestInterceptor('auth.logout')()

      login:
        url: resource.url '/login'
        method: 'post'
        params:
          include: 'user'
        interceptor:
          response: loopback.responseInterceptor('auth.login')()
      findOne:
        url: resource.url '/findOne'
        method: 'get'
      exists:
        url: resource.url '/:id/exists'
        method: 'get'

    User.login
      email: 'johndoe@example.com'
      password: 'demo'
    , (res)->
      console.log 'login.success', arguments

      success = -> console.log 'success', arguments
      err     = -> console.log 'err', arguments

      user = res.user
      user.$logout
        id:null
      , success, err
    , ->
      console.log 'err', arguments

    ###
    User.exists id:4, ->
      console.log arguments

    onSuccess = (res)->
      console.log 'onSuccess', arguments
      return res.data

    onError = ->
      console.log 'onError', arguments
      user = new User username:'dun', email: 'dun@bar.com', password: "dunB@r"
      user.$save()

    onEnd = ->
      console.log 'onEnd', arguments

    (User.findOne
      filter: where: email: 'dun@bar.com'
    ).$promise
      .then(onSuccess, onError)
      .finally onEnd

    User.query().$promise.then ->
      console.log arguments

    onModelErr = (res)->
      console.log '[model][err]', res.data.error.message
    ###


    collection =
      user: {}

    #return
    (model)-> collection[model]


  module.run di (models)->
    User = models 'user'

  return module
