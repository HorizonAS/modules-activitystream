define [
    'jquery'
    'underscore'
    'backbone'
    'modules/config'
    'modules/storage'
    'modules/mapper'
], ($, _, Backbone, config, storage, Mapper) ->

    'use strict';

    class ComponentModel extends Backbone.Model

        initialize: ->
            @type = @get('data').type

        url: ->
            return @get('data').api

        fetch: ->
            model = @
            options = {}
            # Are we grabbing from localStorage
            store = ( model, resp, options ) ->
                map = new Mapper(model.type, resp)
                storage.set 'AS/'+model.type+'/'+model.get('data').aid, JSON.stringify map
                options.success = new Function()
                success map

            success = ( resp ) ->
                if not model.set( resp ) then return false
                model.trigger 'sync', model, resp, options

            if resp = storage.get 'AS/'+@type+'/'+@get('data').aid
                # assign success callback
                options.success = new Function()
                resp = JSON.parse resp
                success resp
                return new $.Deferred().resolve resp

            # Or getting from ajax
            if config.get('api')[@type]
                options = config.get('api')[@type]
                # re-assign success callback
                options.success = store
            else
                options.xhrFields = withCredentials: true # Should this be default?

            Backbone.Model::fetch.call @, options