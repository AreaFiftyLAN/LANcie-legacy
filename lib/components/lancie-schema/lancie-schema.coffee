Polymer 'lancie-schema',
  schema: null

  ###
    Start on DOM loaded
  ###
  ready: ->
    
  ###
    Insert ajax response into variable schema
  ###
  loadedJSON: (event) ->
    @schema = event.currentTarget.response
  