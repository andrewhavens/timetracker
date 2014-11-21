class TimeTracker.Models.Task extends Backbone.Model
  
  urlRoot: '/tasks'
  
  startTime: -> new Date(Date.parse(@get('start')))
  endTime: -> new Date(Date.parse(@get('end')))

  formatTime: (date) ->
    hour = date.getHours()
    hour = hour - 12 if hour > 12
    minute = date.getMinutes()
    minute = '00' if minute == 0
    "#{hour}:#{minute}"

  hours: -> (@endTime().getTime() - @startTime().getTime()) / 3600000

  toDisplayJSON: ->
    data = @toJSON()
    if @isNew()
      data.startTime = null
      data.endTime = null
      data.hours = null
    else
      data.startTime = @formatTime @startTime()
      data.endTime = @formatTime @endTime()
      data.hours = @hours()
    data