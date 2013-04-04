define [
    '../core'
    '../controls'
    'inputio'
    'tpl!templates/views/field-control.html'
], (c, controls, InputIO, templates...) ->

    templates = c._.object ['control'], templates

    FORM_ELEMENTS = 'input,select,textarea'

    controlEvents =
        'keyup input': 'change'
        'change select': 'change'
        'click input[type=radio],input[type=checkbox]': 'change'


    class FieldControl extends controls.Control
        className: 'field-control'

        template: templates.control

        events: controlEvents

        options:
            inputOptions:
                operator:
                    allowEmpty: true

        regionViews:
            operator: controls.OperatorInput
            value: controls.TextInput
            nulls: controls.BooleanInput

        # Gets the value corresonding to the attribute key
        _getAttr: (attr, type) ->
            dataSelector = @dataSelectors[attr]

            # Check if the region and el exist
            if not (region = @[attr])? then return
            if not ($el = region.currentView.$(dataSelector))? then return

            # If this a form element, extract the value otherwise get the attrerty
            if $el.is(FORM_ELEMENTS)
                InputIO.get($el, type)
            else
                $el.attr(@dataAttrs[attr])

        _setAttr: (attr, value) ->
            dataSelector = @dataSelectors[attr]

            # Check if the region and el exist
            if not (region = @[attr])? then return
            if not ($el = region.currentView.$(dataSelector))? then return

            if $el.is(FORM_ELEMENTS)
                InputIO.set($el, value)
            else
                $el.attr(@dataAttrs[attr], value)
            return

        getId: -> @model?.id or @_getAttr('id')
        getOperator: -> @_getAttr('operator', 'string')
        getValue: -> @_getAttr('value', @model?.get('simple_type'))
        getNulls: -> @_getAttr('nulls', 'boolean')

        setId: (value) -> not @model?.id and @_setAttr('id', value)
        setOperator: (value) -> @_setAttr('operator', value)
        setValue: (value) -> @_setAttr('value', value)
        setNulls: (value) -> @_setAttr('nulls', Boolean(value))







    { FieldControl }
