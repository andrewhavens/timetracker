class TimeTracker.Views.TaskList extends Backbone.View

  template: JST['tasks/list']

  tagName: 'table'

  initialize: (options) ->
    @clients = options.clients
    @clients.on 'add', @addOneNew, @

  render: ->
    @$el.html @template()
    @addAll()
    @addOneNew()
    @

  addAll: ->
    @collection.each(@addOne, @)

  addOne: (task)->
    view = new TimeTracker.Views.TaskRow(model: task, clients: @clients)
    @$("tbody").append(view.render().el)

  addOneNew: ->
    model = new TimeTracker.Models.Task
    @addOne model
    if @$('tbody tr').length > 1
      last_end = @$('tr').last().prev().find('input[name="end"]').val()
      @$('tr').last().find('input[name="start"]').val(last_end)
      @$('tr:last-of-type input[name="end"]').trigger 'focus'
      match = /^(\d+):?(\d*)$/.exec(last_end)
      if match
        hour = match[1]
        if hour > 0 && hour < 8 # assume time wont be entered before 8am
          hour = +hour + 12
        minute = match[2]
        datetime = new Date
        datetime.setHours(hour)
        datetime.setMinutes(minute)
        datetime.setSeconds(0)
        datetime.setMilliseconds(0)
        model.set 'start', datetime
    else
      @$('tr:last-of-type input[name="start"]').trigger 'focus'