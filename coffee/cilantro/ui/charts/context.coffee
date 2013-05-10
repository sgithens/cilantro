define [
    '../core'
    './core'
    './utils'
    'tpl!templates/views/chart.html'
], (c, charts, utils, templates...) ->

    templates = c._.object ['chart'], templates

    # Defines a class for charting the distribution of a context. This chart
    # responds to changes in the context model and updates the chart 
    # according to those changes. This chart is NOT meant to be interactive, 
    # only responsive.
    class ContextChart extends charts.Chart
        template: templates.chart

        ui:
            chart: '.chart'
            heading: '.heading'
            status: '.heading .status'

        getChartOptions: (resp) ->
            options = utils.processResponse(resp, [@model])

            $.extend true, options, @chartOptions
            options.chart.renderTo = @ui.chart[0]
            return options

        getField: -> @model.id

        getValue: (options) -> @value
     
        # Removes all PlotBands and PlotLines from all axes of this chart.
        clearPlotControls: ->
            # We should only ever add PlotBands and PlotLines to the first 
            # X axis but I loop through all of them here just to be certain.
            # Currently, there is nothing that adds plot controls to the Y axis
            # but I clear that too just in case it changes in the future and we 
            # start add horizontal plot controls too.
            for axis in @chart.xAxis.concat @chart.yAxis
                for obj in axis.plotLinesAndBands
                    axis.removePlotBandOrLine(obj.id)

        # Adds a new PlotBand on the first X axis of this chart spanning
        # the range [from, to] and drawn in the supplied color.
        addPlotBand: (from, to, color=charts.Chart.INCLUDE_COLOR) =>
            @chart.xAxis[0].addPlotBand({
                color: color,
                from: from,
                to: to
            })

        # Adds a new PlotLine on the first X axis of this chart at the 
        # given x coordinate in the color and of the width supplied as 
        # arguments.
        addPlotLine: (xCoord, color, width=charts.Chart.PLOT_LINE_WIDTH) =>
            @chart.xAxis[0].addPlotLine({
                value: xCoord,
                color: color,
                width: width
            })

        updateChart: =>
            # Give up now if we don't have a value or the operator isn't defined
            if (not @value?) or (not @operator?)
                return

            # Clear any of the old plot controls from the previous operator
            @clearPlotControls()

            # Find the min and max extremes of the chart in case the operator
            # needs to use them in a PlotBand draw call.
            xExtremeMin = @chart.xAxis[0].getExtremes().min
            xExtremeMax = @chart.xAxis[0].getExtremes().max

            # Figure out what we need to do based on the new operator
            # TODO: Support all the remaining operators:
            #       (-)isNull, (-)(i)exact, (-)(i)contains, in, excludes
            switch @operator
                when "lt"
                    @addPlotBand(xExtremeMin, @value)
                    @addPlotLine(@value, charts.Chart.EXCLUDE_COLOR)
                when "lte"
                    @addPlotBand(xExtremeMin, @value)
                when "gt"
                    @addPlotBand(@value, xExtremeMax)
                    @addPlotLine(@value, charts.Chart.EXCLUDE_COLOR)
                when "gte"
                    @addPlotBand(@value, xExtremeMax)
                when "range", "-range"
                    # Verify that there are 2 values to give us a min and max 
                    # for the PlotBand being drawn.
                    if @value.length != 2
                        return

                    color = if @operator == "range" then charts.Chart.INCLUDE_COLOR else charts.Chart.EXCLUDE_COLOR
                    @addPlotBand(@value[0], @value[1], color)

        setOperator: (operator) =>
            @operator = operator
            @updateChart()

        setValue: (value) => 
            @value = value
            @updateChart()

        removeChart: (event) ->
            super
            if @node then @node.destroy()

        onRender: -> 
            @$el.addClass 'loading'

            # Explicitly set the width of the chart so Highcharts knows
            # how to fill out the space. Otherwise if this element is
            # not in the DOM by the time the distribution request is finished,
            # the chart will default to an arbitrary size.
            if @options.parentView?
                @ui.chart.width(@options.parentView.$el.width())

            @model.distribution (resp) =>
                options = @getChartOptions(resp)
                @renderChart(options)


    { ContextChart }
