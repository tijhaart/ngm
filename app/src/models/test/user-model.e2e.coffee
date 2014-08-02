(require __base '/test/setup').prepEnv()




# models = require '../src/models'
# helper = require __base '/app/plugins/model/src/model'

###*
 * 1. get registered packages (/app/src/index.coffe, getPackagesCfg)
 * 2. filter required packages
 * 3. create architect app
 * 4. after app created then run tests
 * 
 * inject 'plugin.module'
###

# imports =
# 	"plugin.model.helper": ->

# describe 'foobar', ->
# 	beforeEach ->
# 		models {}, imports, register = ->

# 	one = null

# 	Given ->
# 		one = 1
# 	Then 'should one == ' + one, ->
# 		expect(one).to.equal(1)