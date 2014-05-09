do (module)->

  module.factory 'hwMessageFactory', ->
    Message = ->
      @message = 'Hello world'

      @sendMessage = =>
        console.log @message
        return
      return @

    # return
    create: -> new Message()