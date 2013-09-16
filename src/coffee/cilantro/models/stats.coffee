define [
    'underscore'
    'backbone'
    '../core'
], (_, Backbone, c) ->

    # Prettifies a key for display
    prettyKey = (key) ->
        key = key.replace(/[_\-\s]+/, ' ').trim()
        key.charAt(0).toUpperCase() + key.substr(1)

    # Prettifies a value for display
    prettyValue = (value) ->
        if _.isNumber(value) then c.utils.prettyNumber(value) else value


    class StatModel extends Backbone.Model


    class StatCollection extends Backbone.Collection
        model: StatModel

        parse: (attrs) ->
            stats = []
            for key, value of attrs
                if key.slice(0, 1) is '_' then continue
                stats.push
                    label: prettyKey(key)
                    value: prettyValue(value)
            return stats


    { StatModel, StatCollection }