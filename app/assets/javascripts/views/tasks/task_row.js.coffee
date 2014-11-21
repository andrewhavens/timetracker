class TimeTracker.Views.TaskRow extends Backbone.View

  tagName: 'tr'

  viewTemplate: JST['tasks/row_view']
  editTemplate: JST['tasks/row_edit']

  events:
    'keyup input[name="start"], input[name="end"]': 'setTime'
    'keydown input[name="start"], input[name="end"]': 'stripColons'
    'keyup input[name="description"]': 'setData'
    'click .remove': 'destroy'
    'keypress input': 'nextOnEnter'
    # 'blur input[name="description"]': 'next'

  initialize: (options) ->
    @clients = options.clients

  render: ->
    data = @model.toDisplayJSON()
    data.clients = @clients.toJSON()
    @$el.html @editTemplate(data)
    @

  setTime: (event) ->
    return if event.keyCode == 8 # backspace
    return if event.keyCode == 37 # left
    return if event.keyCode == 38 # up
    return if event.keyCode == 39 # right
    return if event.keyCode == 40 # down
    input = $(event.target)
    value = input.val().replace(':','')
    match = /^(\d\d?)(\d\d)$/.exec(value)
    if match
      hour = match[1]
      timehour = hour
      if hour > 0 && hour < 8 # assume time wont be entered before 8am
        timehour = +hour + 12
      minute = match[2]
      datetime = new Date
      datetime.setHours(timehour)
      datetime.setMinutes(minute)
      datetime.setSeconds(0)
      datetime.setMilliseconds(0)
      @model.set input.attr('name'), datetime
      if value.length == 3 || value.length == 4
        input.val("#{hour}:#{minute}")

  stripColons: (event)->
    return false if $(event.target).val().indexOf(':') != -1 && event.keyCode == 186 # colon

  setData: (event) ->
    input = $(event.target)
    @model.set input.attr('name'), input.val()

  destroy: ->
    view = @
    @model.destroy
      success: (model, response)->
        view.remove()

  next: ->
    @model.set 'client_id', @$('select option:selected').val()
    addBlankTaskRow = @model.isNew()
    @model.save null,
      success: (model)->
        $('<span class="success_alert">Saved</span>').prependTo('body').fadeOut(1000)
        @clients.add model.toJSON() if addBlankTaskRow
      error: (model, xhr, options)->
        alert 'error saving record!'
        console.log 'error saving record!', model, xhr, options


  nextOnEnter: (event)->
    return unless event.keyCode == 13
    @next()
