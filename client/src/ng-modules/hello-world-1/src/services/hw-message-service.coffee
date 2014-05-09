do (module)->

  module.service 'hwMessageService', ->
    @message = 'Hello world'

    @sendMessage = =>
      console.log @message
      return

    return @