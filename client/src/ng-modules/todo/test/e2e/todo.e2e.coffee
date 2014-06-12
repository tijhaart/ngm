require 'jasmine-given'

describe "todo", ->

  it "should navigate to /app", ->
    browser.get '/app'