Polymer 'lancie-tournaments',
  tournaments: null

  ###
    Start on DOM loaded
  ###
  ready: ->


  ###
    Insert ajax response into variable tournaments
  ###
  loadedJSON: (event) ->
    @tournaments = event.currentTarget.response