do (window)->
  ###*
   * SweetJS macro "di" is slowing the gulp build down and therefore the di tag remains.
   * Propably we'll use another angular annotation workaround for proper minification
   * of angular providers etc...
  ###
  window.di = (fn)-> return fn