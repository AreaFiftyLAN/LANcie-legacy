Polymer 'lancie-sponsors',
  sponsors: null

  ###
    Start on DOM loaded
  ###
  ready: ->

  ###
    Insert ajax response into variable tournaments
  ###
  loadedJSON: (event) ->
    @sponsors = event.currentTarget.response