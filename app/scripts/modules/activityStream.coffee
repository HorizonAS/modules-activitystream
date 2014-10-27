define [
    'backbone'
    'jquery'
    'underscore'
    'sailsio'
    'modules/config'
    'modules/logger'
    'modules/routing'
    'modules/filterManager'
    'modules/activity'
    'views/stream'
    'modules/user',
], (Backbone, $, _, io, config, Logger, Routing, FilterManager, Activity, StreamView, User) ->

    'use strict'

    class ActivityStreamModule

        constructor: ->
            @logger = new Logger() # Base Init that loads our other modules
            @stream = new StreamView() # Stream Module Init
            @activity = new Activity(@stream) # Activity Module Init
            @routing = new Routing()
            window.r = @routing

        ready: (options) ->
            @user = new User(options.user)
            if options.activityStreamServiceAPI
                options.baseUrl = options.activityStreamServiceAPI + 'api/v1/'
            config.overwrite(options)
            @filterManager = new FilterManager(options.filters)
            @filterManager.setFilter('actor', [@user.type, @user.id])
            @init()

        init: () ->
            @setAuth config.get('activityStreamServiceAPI') + 'api/v1', @user


        setAuth: (url, user) ->
            # Establish/reinit a session cookie with the Activity Streams server
            # Without sending an empty JSONP call to the AS server, we won't get
            # an authentication cookie that will allow us to establish the socket.
            # Needs to be JSONP as this is technically considered a 3rd party domain.
            # If a cookie already exists, and the sesion is valid, then the same cookie
            # will be used.
            #
            # The AS Service will respond with a JSON response (res.json()), so we just
            # check to make sure that the call completed and that the status code is not 0.
            # Otherwise, the calls on the Service end would need to be converted to res.jsonp().
            # JSONP has some security issues that we don't want to expose on the
            # Service side.  See http://stackoverflow.com/questions/613962/is-jsonp-safe-to-use

            $.ajax
                url: url
                dataType: 'jsonp'
                timeout: 12000
                cache: false
                success: (data) =>
                    @createSocket @user
                error: (xhr, textStatus) =>
                    @stream.error("Error: " + textStatus )

        createSocket: () ->
            @socket = io.connect(config.get('activityStreamServiceAPI'))
            @socket.on 'connect', =>
                @socketStart()

        socketStart: () =>
            self = this
            @stream.ready()

            filters = config.get('filters')
            urlContext = @filterManager.getFiltersForUrl()
            url = @routing.urlForContext urlContext

            @socket.get url, (data) =>

                if data.status == 404 then throw new Error(data.status)
                _.each data, (o) =>
                        if o.items
                          _.each o.items, (b) =>
                               if self.filterManager.matchActivity(b)
                                    @stream.addActivity(b)
                        else console.log 'User\'s followed, have no items'


            if config.get('enableFollowingData')
                url = @routing.get 'following', urlContext
                @socket.get url, (data) =>
                    if data.status == 404 then throw new Error(data.status)
                    if data.length > 0 then _.each data, @stream.addActivity
                    else console.log 'User\'s followed, have no items'

            # Important for this to happen after the GET request
            # because we want updates to happen after initial load
            @socket.post '/api/v1/subscribe', { user: @user.id }

            @socket.on 'message', messageReceived = (message) =>
                if @matchActivity(message.data.data)
                    @activity.parseMessage(message.data.data, message.verb)
