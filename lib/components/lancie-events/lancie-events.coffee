Polymer 'lancie-events',
  events: null

  ###
    Start on DOM loaded
  ###
  ready: ->


  ###
    Insert ajax response into variable events
  ###
  loadedJSON: (event) ->
    @events = event.currentTarget.response