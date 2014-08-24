require 'mocha-cakes'

request = require 'supertest'
expect = (require 'chai').expect

Feature 'Example test suite'
	
	Scenario 'success', =>
		Then "it should do ...", =>
			expect(true).to.equal(true)