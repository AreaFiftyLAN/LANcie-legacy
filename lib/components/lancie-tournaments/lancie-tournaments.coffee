Polymer 'lancie-tournaments',
  tournaments: null

  ###
    Start on DOM loaded
  ###
  ready: ->
    console.log "Loaded"

  ###

  ###
  loadedJSON: (event) ->
    @tournaments = event.currentTarget.response