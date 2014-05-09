do (module)->
  module.factory 'uiDialogFactory', ->
    collection = []

    Dialog =
      close: ->
      open: ->
      isOpen: ->
      refresh: ->

    create: -> 
      collection.push dialog = Object.create Dialog
      return dialog