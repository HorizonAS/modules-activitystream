define [
    'underscore'
    'modules/config'
], (_, config) ->

    'use strict';

    class Routing
        routes:
            # Gets a list of all activites for a given user
            # {@actor_type} = user type (i.e. mmdb_user, etc.)
            # {@actor_aid} = MMDB user id
            'actor_all': 'actor/{actor_type}/{actor_aid}/activities'

            # Gets a list of all activities for a given user based on the verb
            # Examples of verbs:  favorited, liked, followed, etc.
            # {@actor_type} = user type (i.e. mmdb_user, etc.)
            # {@actor_aid} = MMDB user id
            # {@verb_type} = favorited, followed, liked, etc.
            'actor_verb': 'actor/{actor_type}/{actor_aid}/{verb_type}'

            # Gets a list of all activities for a given user based on the verb and object
            # Examples of verbs:  favorited, liked, followed, etc.
            # Examples of objects: cms_article, blog_post, etc.
            # {@actor_type} = user type (i.e. mmdb_user, etc.)
            # {@actor_aid} = MMDB user id
            # {@verb_type} = favorited, followed, liked, etc.
            # {@object_type} = object type (i.e. cms_article, blog_post etc.)
            'actor_verb_object':  'actor/{actor_type}/{actor_aid}/{verb_type}/{object_type}'

            # Gets a list of all activites for the followed users
            # of the given user
            # {@actor_type} = user type (i.e. mmdb_user, etc.)
            # {@actor_id} = user id
            'following': 'proxy/{actor_type}/{actor_id}/'

            # Gets a list of all activites for a given user
            # {@object_type} = object type (i.e. cms_article, blog_post etc.)
            # {@object_aid} = MMDB user id
            'followers_all': 'object/{object_type}/{object_aid}/activities'


        # Given a route's name and context, returns the complete url
        # {@name} route's name (i.e: following, followers_all)
        # {@ctx} object (i.e: {actor_aid: 1, actor_type: 'db_user'} )
        get: (name, ctx) ->
            return '' if false == @routes.hasOwnProperty name

            url = @routes[name]
            for name, value of ctx
                regex = new RegExp("{#{name}}", 'g')
                url = url.replace(regex, value)
            config.get('baseUrl') + url


        # Given a context it returns the more specific url to that context
        # {@ctx} object (i.e: {actor_aid: 1, actor_type: 'db_user'} )
        # {return} string
        urlForContext: (ctx) ->
            bestMatch = ''
            bestCount = -1
            for name, path of @routes
                re = /\{(.+?)\}/gi
                count = 0
                url = path
                while urlArg = re.exec(path)
                    if ctx.hasOwnProperty(urlArg[1])
                        count++
                    else # no match
                        count = -1
                        break

                if count > bestCount
                    bestCount = count
                    bestMatch = name


            return @get bestMatch, ctx