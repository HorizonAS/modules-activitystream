define [
    'underscore'
    'modules/config'
], (_, config) ->

    'use strict';

    class User

        constructor: (args) ->
            @type = args.type
            @id = args.id

        getAll: () ->
            # Gets a list of all activites for a given user
            # {@type} = user type (i.e. mmdb_user, etc.)
            # {@id} = MMDB user id
            config.get('baseUrl') + "actor/#{@type}/#{@id}/activities"

        getAllVerb: (verbType) ->
            # Gets a list of all activities for a given user based on the verb
            # Examples of verbs:  favorited, liked, followed, etc.
            # {@type} = user type (i.e. mmdb_user, etc.)
            # {@id} = MMDB user id
            # verbType = favorited, followed, liked, etc.
            config.get('baseUrl') + "actor/#{@type}/#{@id}/#{verbType}"


        getAllVerbObject: (verbType, objectType) ->
            # Gets a list of all activities for a given user based on the verb and object
            # Examples of verbs:  favorited, liked, followed, etc.
            # Examples of objects: cms_article, blog_post, etc.
            # {@type} = user type (i.e. mmdb_user, etc.)
            # {@id} = MMDB user id
            # verbType = favorited, followed, liked, etc.

            config.get('baseUrl') + "actor/#{@type}/#{@id}/#{verbType}/#{objectType}"

        getFollowing: () ->
            # Gets a list of all activites for the followed users
            # of the given user
            # {@type} = user type (i.e. mmdb_user, etc.)
            # {@id} = user id
            config.get('baseUrl') + "proxy/#{@type}/#{@id}/"
