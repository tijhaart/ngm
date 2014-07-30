###**
 * @ngdoc object
 * @name utilEvent
 *
 * @description [description]
 * 
###
module = do ( module = angular.module('utilEvent', []) )-> 

	###*
	 * Simple wrapper for ui-router $stateChange[type] events
	 * @param  {Object} $rootScope
	 * @return {Object} $stateChange
	###
	module.service '$stateChange', ($rootScope)->

	  @start = (callback)->
	    $rootScope.$on '$stateChangeStart', (e, toState, toParams, fromState, fromParams)->
	      callback.apply this, [
	        e,
	        { 
	        	state: toState
	        	params: toParams 
	        },
		      { 
		      	state: fromState
		      	params: fromParams
		      }
	      ]
	    return this

	  @error = (callback)->
	    $rootScope.$on '$stateChangeError', (e, toState, toParams, fromState, fromParams, err)->
	      callback.apply this, [
	        e,
	        { 
	        	state: toState
	        	params: toParams 
	        },
		      { 
		      	state: fromState
		      	params: fromParams
		      }
	        err
	      ]
	    return this

	  @success = (callback)->
	    $rootScope.$on '$stateChangeSuccess', (e, toState, toParams, fromState, fromParams)->
	      callback.apply this, [
	        e,
	        { 
	        	state: toState
	        	params: toParams 
	        },
		      { 
		      	state: fromState
		      	params: fromParams
		      }
	      ]
	    return this

	  return this


	return module
