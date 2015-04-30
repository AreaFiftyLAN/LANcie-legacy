Polymer 'lancie-countdown',
  tillEndTime: null

  oneSecond:  1000
  oneMinute:  1000 * 60
  oneHour:    1000 * 60 * 60
  oneDay:     1000 * 60 * 60 *24

  days: ""
  hours: ""
  minutes: ""
  seconds: ""

  ###
    Start on DOM loaded
  ###
  ready: ->
    @setup()

  ###
    Setup for the countdown
  ###
  setup: ->
    @tillEndTime = new Date(@endtime) - new Date()

    @days     = @addZero Math.floor(@tillEndTime / @oneDay);
    @hours    = @addZero Math.floor((@tillEndTime % @oneDay) / @oneHour);
    @minutes  = @addZero Math.floor((@tillEndTime % @oneHour) / @oneMinute);
    @seconds  = @addZero Math.floor((@tillEndTime % @oneMinute) / @oneSecond);
    
    @timer()

  ###
    The MAGIC countdown
  ###
  timer: ->
    if @seconds-- <= 10 then @seconds = "0" + @seconds
    if @seconds is "0-1"
      @seconds = 59

      if @minutes-- <= 10 then @minutes = "0" + @minutes
      if @minutes is "0-1"
        @minutes = 59

        if @hours-- <= 10 then @hours = "0" + @hours
        if @hours is "0-1"
          @hours = 23
          if @days-- <= 10 then @days = "0" + @days

    if @days > 0 or @hours > 0 or @minutes > 0 or @seconds > 0 
      @.async(@.timer, null, 1000);

  ###
    Add a zero in front of a number if this number in below 10
  ###
  addZero: (number) ->
    if number < 10 then "0" + number else number