Polymer 'lancie-timetable',
  timetable: null

  ###
    Start on DOM loaded
  ###
  ready: ->
    
  ###
    Insert ajax response into variable timetable
  ###
  loadedJSON: (event) ->
    @timetable = event.currentTarget.response
  