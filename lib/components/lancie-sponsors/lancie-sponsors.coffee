Polymer 'lancie-sponsors',
  sponsors: null

  ###
    Start on DOM loaded
  ###
  ready: ->

  loadedJSON: (event) ->
    console.log "Loaded - JSON"
    @sponsors = event.currentTarget.response