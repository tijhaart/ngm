Feature 'Demo',
'As a tester',
"I don't want to manually require/include all the things",
'So I can focus on writing tests', ->

	Given =>
		@a = 1

	Scenario 'success', =>
		after =>
			@a = 1

		When '2 is added to a', =>
			@a = @a + 2
		Then 'a should be 3', =>
			expect(@a).to.equal(3)

	Scenario 'error', =>
		subtractTwo = (value)->
			if (value - 2) >= 0
				return value = value - 2
			else
				return value

		When 'two is subtracted from a', =>
			subtractTwo @a
		Then 'it should not have updated a', =>
			expect(@a).to.equal(1)