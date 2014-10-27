define [
], () ->

    'use strict';

    class FilterManager

        constructor: (filters)->
           @filterBag = {}
           @addFilters(filters)

        addFilters: (filters) ->
            return unless filters?
            for key of filters
              @setFilter key, filters[key].split '/'

        # Set filters to the filter bag
        # name is a string containing the filter name, i.e: verb, object.
        # values is an array containing either: [type] or [type, id]. Example: ['db_user'] or ['cms_article', 1]
        setFilter: (name, values) ->
            if values.length == 1
                @filterBag[name] =
                    'type': values[0]
            else if values.length == 2
                @filterBag[name] =
                    'type': values[0]
                    'aid' : values[1]

        matchActivity: (message) ->
            for name, value of @filterBag
                if message.hasOwnProperty name
                    data = if message[name].data.type? then message[name].data else message[name]

                    if value.hasOwnProperty 'aid'
                        if value.type != data.type or value.aid.toString() != data.aid
                            return false
                    else
                        if value.type != data.type
                            return false
            return true

        getFiltersForUrl: () ->
            urlBag = {}
            for name, value of @filterBag
                urlBag["#{name}_type"] = value.type
                urlBag["#{name}_aid"] = value.aid if value.hasOwnProperty 'aid'
            return urlBag