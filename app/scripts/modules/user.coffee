define [
    'underscore'
    'modules/config'
], (_, config) ->

    'use strict';

    class User

        constructor: (args) ->
            @type = args.type
            @id = args.id
