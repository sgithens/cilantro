define [
    'backbone'
    'underscore'
    './core'
], (Backbone, _, c) ->

    class Router extends Backbone.Router
        options:
            main: 'body'
            root: null

        initialize: (options) ->
            @options = _.extend({}, _.result(@, 'options'), options)
            @_registered = {}
            @_loaded = []
            @_routes = {}
            @_handlers = {}

        _unloadAll: =>
            @_unload(@_registered[id], false) for id in @_loaded.slice()
            return

        _loadAll: =>
            if not (ids = @_routes[Backbone.history.fragment])? then return
            @_load(@_registered[id]) for id in ids
            return

        _unload: (route, force=true) =>
            if route.route? or force and (idx = @_loaded.indexOf(route.id)) >= 0
                @_loaded.splice(idx, 1)
                if (view = route._view)?
                    view?.$el.hide()
                    view.trigger?('router:unload', @, Backbone.history.fragment)

        _load: (options) =>
            # If the view has not be loaded before, check if it's a
            # module string and loader asynchronously
            if not options._view?
                if _.isString options.view
                    require [options.view], (klass) =>
                        options._view = new klass options.options
                        @_render(options)
                        @_loaded.push(options.id)

                    return

                options._view = options.view

            # XXX: this is hack until #229 is resolved. Views can be rendered
            # prior to the session being initialized so the API version is not
            # yet know. Since views depend on the API version to toggle certain
            # features, rendering must wait.
            if c.session.current?
                c.session.current.open().done =>
                    @_render(options)
            else
                @_render(options)
            @_loaded.push(options.id)

        _render: (options) =>
            view = options._view
            if not view._rendered
                view._rendered = true
                if options.el isnt false
                    if options.el?
                        target = Backbone.$(options.el, @options.main)
                    else
                        target = Backbone.$(@options.main)
                    target.append(view.el)
                    view.render?()

            view.$el.show()
            view.trigger?('router:load', @, Backbone.history.fragment)
            return

        _register: (options) ->
            if @_registered[options.id]?
                throw new Error "Route #{ options.id } already registered"

            # Clone since the options options will be augmented
            options = _.clone options

            # Non-routable view.. immediately load and only once
            if not options.route?
                @_load(options)
            else if not @_handlers[options.route]?
                @_routes[options.route] = []
                @_handlers[options.route] = handler = =>
                    @_unloadAll()
                    @_loadAll()
                    return
                @route options.route, options.id, handler
            if options.route?
                @_routes[options.route].push options.id
            @_registered[options.id] = options

        # Returns a route config by id
        get: (id) ->
            @_registered[id]

        # Returns true if the route config is registered with this router and
        # is navigable.
        isNavigable: (id) ->
            (config = @get(id))? and config.navigable isnt false

        # Checks if the current fragment or id is currently routed
        isCurrent: (fragment) ->
            if fragment is Backbone.history.fragment
                return true
            if (ids = @_routes[Backbone.history.fragment])?
                for id in ids
                    if fragment is id then return true
            return false

        # Returns true if the supplied route is in the list of routes known
        # to this router and false if it isn't known to this router.
        hasRoute: (route) ->
            return @_routes.hasOwnProperty(route)

        # Attempt to get the corresponding config if one exists and use
        # the route specified on the config. This provides a means of
        # aliasing a name/key to a particular route.
        navigate: (fragment, options) ->
            if @isNavigable(fragment)
                fragment = @get(fragment).route
            super(fragment, options)

        # Register one or more routes
        register: (routes) ->
            if not _.isArray routes
                routes = [routes]
            for options in routes
                if not options.view then continue
                @_register options
            return

        # Unregister a route by id
        unregister: (id) ->
            if (options = @_registered[id])?
                @_unload(options)
                delete @_registered[id]
                if (idx = @_routes[options.route]?.indexOf(id)) >= 0
                    @_routes[options.route].splice(idx, 1)
            return

        # Shortcut for starting the Backbone.history
        start: ->
            root = @options.root or '/'
            if root.charAt(root.length-1) isnt '/'
                root = root + '/'
            Backbone.history.start(root: root, pushState: true)

    { Router }
