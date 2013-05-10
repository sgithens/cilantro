define [
    './core'
    './charts/dist'
    './charts/context'
    './charts/axis'
    './charts/editable'
], (c, mods...) ->

    c._.extend {}, mods...
