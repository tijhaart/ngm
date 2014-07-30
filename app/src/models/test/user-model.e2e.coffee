# require 'mocha-cakes'
expect = (require 'chai').expect

describe 'User model', ->

	Scenario 'foobar', ->

		model = null

		Given "model user", -> 
			model = 'user'
		Then "it should have the user model", ->
			expect(model).to.equal('user')

			Scenario 'after foobar then blaat', ->
				prev = null
				Given ->
					prev = model
					model = 'bar'
				Then 'it should be bar', ->
					expect(model).to.equal 'bar'
				And 'prev to equal user', ->
					expect(prev).to.equal 'user'
