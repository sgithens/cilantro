define [
    './core'
    'tpl!templates/views/paginator.html'
], (c, templates...) ->

    templates = c._.object ['links'], templates


    # Set of pagination links that are used to control/navigation the bound
    # model.
    #
    # The model is assumed to implement the 'paginator protocol', see
    # cilantro/models/paginator
    class Paginator extends c.Marionette.ItemView
        template: templates.links

        requestDelay: 250 # In milliseconds

        className: 'paginator'

        ui:
            first: '[data-page=first]'
            prev: '[data-page=prev]'
            next: '[data-page=next]'
            last: '[data-page=last]'
            pageCount: '.page-count'
            currentPage: '.current-page'

        modelEvents:
            'change:pagecount': 'renderPageCount'
            'change:currentpage': 'renderCurrentPage'

        events:
            'click [data-page=first]': 'requestChangePage'
            'click [data-page=prev]': 'requestChangePage'
            'click [data-page=next]': 'requestChangePage'
            'click [data-page=last]': 'requestChangePage'

        initialize: ->
            @_changePage = c._.debounce(@changePage, @requestDelay)

        onRender: ->
            if not @model.pageIsLoading()
                @renderPageCount(@model, @model.getPageCount())
                @renderCurrentPage(@model, @model.getCurrentPageStats()...)

        renderPageCount: (model, value, options) ->
            @ui.pageCount.text(value)

        renderCurrentPage: (model, value, options) ->
            @ui.currentPage.text(value)
            @ui.first.prop('disabled', !!options.first)
            @ui.prev.prop('disabled', !!options.first)
            @ui.next.prop('disabled', !!options.last)
            @ui.last.prop('disabled', !!options.last)

        changePage: (newPage) ->
            switch newPage
                when "first" then @model.getFirstPage()
                when "prev" then @model.getPreviousPage()
                when "next" then @model.getNextPage()
                when "last" then @model.getLastPage()
                else console.log "Unknown paginator direction: #{ newPage }"

        requestChangePage: (event) ->
            @_changePage $(event.target).data('page')
                    

    # Page for containing model-based data
    class Page extends c.Marionette.ItemView


    # Page for containing collection-based data
    class ListingPage extends c.Marionette.CollectionView
        itemView: Page


    # Renders multiples pages as requested, but only shows the current
    # page. This is delegated by the paginator-based collection bound to
    # this view.
    #
    # The contained views may be model-based or collection-based. This is
    # toggled based on the `options.list` flag. If true, the `listView`
    # will be used as the item view class. Otherwise the standard `itemView`
    # will be used for model-based data.
    #
    # If list is true, the `listViewOptions` will be called to produce the
    # view options for the collection view. By default the item passed in
    # is assumed to have an `items` collection on it that will be used.
    class PageRoll extends c.Marionette.CollectionView
        options:
            list: true

        itemView: Page

        listView: ListingPage

        getItemView: ->
            if @options.list then @listView else @itemView

        listViewOptions: (item, index) ->
            collection: item.items
            index: index

        itemViewOptions: (item, index) ->
            if @options.list
                return @listViewOptions(item, index)
            return super(item, index)

        collectionEvents:
            'change:currentpage': 'showCurentPage'

        showCurentPage: (model, num, options) ->
            @children.each (view) ->
                view.$el.toggle(view.model.id is num)


    { Paginator, Page, ListingPage, PageRoll }
