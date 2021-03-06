define [
	'localconfig'
	'underscore'
], (defaults, _) ->

	'use strict'

	class Config
		constructor: () ->
			@conf = defaults

		overwrite: (args...) ->
			return @conf unless args[0]
			for i of args
				for own key, val of args[i]
					@conf[key] = val

		get: (attr) ->
			@conf[attr] if @conf[attr]?

		extend: (args...) ->
			return {} unless args[0]
			for i of args
				for own key, val of args[i]
					if not args[0][key]? and typeof val isnt 'object'
						args[0][key] = val
					else if args[0][key]? and typeof val isnt 'object'
						continue
					else if not args[0][key]? and val instanceof Array
						args[0][key] = val
					else if args[0][key]? and val instanceof Array
						continue
					else
						args[0][key] = {} unless args[0][key]?
						args[0][key] = @extend args[0][key], val
			args[0]

	return new Config()
