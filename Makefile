.PHONY: test testw

REPORTER ?= spec
FILE ?= server/src/**/test/*.coffee

test:
	@./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		--compilers coffee:coffee-script/register \
		--require test/setup.coffee \
		--ui bdd \
		$(FILE)

testw:
	@./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		--compilers coffee:coffee-script/register \
		--require test/setup.coffee \
		--ui bdd \
		--watch \
		$(FILE)